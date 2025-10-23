module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg [1:0] state
);

always @(posedge clk) begin
    case(state)
        2'b00: begin
            if (~a && b) begin
                state <= 2'b01;
            end else if (a && b) begin
                state <= 2'b00;
            end else begin
                state <= 2'b00;
            end
        end
        2'b01: begin
            if (~a && b) begin
                state <= 2'b01;
            end else if (a && b) begin
                state <= 2'b10;
            end else begin
                state <= 2'b01;
            end
        end
        2'b10: begin
            if (~a && b) begin
                state <= 2'b01;
            end else if (a && b) begin
                state <= 2'b10;
            end else begin
                state <= 2'b00;
            end
        end
        default: state <= 2'b00;
    endcase
end

always @(*) begin
    case(state)
        2'b00: q = (a && ~b) || (~a && b);
        2'b01: q = 1'b1;
        2'b10: q = 1'b1;
        default: q = 1'b0;
    endcase
end

endmodule