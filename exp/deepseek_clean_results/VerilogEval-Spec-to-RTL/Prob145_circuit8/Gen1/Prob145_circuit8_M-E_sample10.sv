module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;
reg prev_a;

always @(posedge clock) begin
    prev_a <= a;
    
    case (state)
        2'b00: begin
            if (a & ~prev_a) begin
                p <= 1;
                q <= 0;
                state <= 2'b01;
            end
            else begin
                p <= 0;
                q <= 0;
            end
        end
        2'b01: begin
            p <= 0;
            q <= 1;
            state <= 2'b10;
        end
        2'b10: begin
            if (~clock && a && ~prev_a) begin
                p <= 0;
                q <= 0;
                state <= 2'b00;
            end
            else if (a & ~prev_a) begin
                p <= 1;
                q <= 0;
                state <= 2'b01;
            end
            else begin
                p <= 0;
                q <= 0;
                state <= 2'b00;
            end
        end
        default: state <= 2'b00;
    endcase
end

always @(negedge clock) begin
    if (a & ~prev_a) begin
        p <= 0;
        q <= 0;
        state <= 2'b00;
    end
end

initial begin
    state = 2'b00;
    prev_a = 0;
    p = 0;
    q = 0;
end

endmodule