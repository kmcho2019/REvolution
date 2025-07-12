module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;
reg a_prev;
reg p_prev;

parameter IDLE = 2'b00;
parameter ACTIVE = 2'b01;
parameter HOLD = 2'b10;

always @(posedge clock) begin
    a_prev <= a;
    p_prev <= p;
    
    case (state)
        IDLE: begin
            if (a) begin
                p <= 1'b1;
                state <= ACTIVE;
            end
            else begin
                p <= 1'b0;
            end
        end
        ACTIVE: begin
            p <= a_prev;
            state <= HOLD;
        end
        HOLD: begin
            p <= 1'b0;
            if (a_prev) begin
                state <= ACTIVE;
            end
            else begin
                state <= IDLE;
            end
        end
        default: state <= IDLE;
    endcase
end

always @(negedge clock) begin
    if (p_prev) begin
        q <= 1'b1;
    end
    else if (~a) begin
        q <= 1'b0;
    end
end

endmodule