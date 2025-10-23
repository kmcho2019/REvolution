module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state; // Reduced state bits from 3 to 2 for states A, B, C, D

always @(posedge clk) begin
    if (~resetn) state <= 2'b00; // Reset to state A
    else begin
        case (state)
            2'b00: // State A
                state <= (r[0]) ? 2'b01 : (r[1]) ? 2'b10 : (r[2]) ? 2'b11 : 2'b00;
            2'b01: // State B
                state <= (r[0]) ? 2'b01 : 2'b00;
            2'b10: // State C
                state <= (r[1]) ? 2'b10 : 2'b00;
            2'b11: // State D
                state <= (r[2]) ? 2'b11 : 2'b00;
            default: state <= 2'b00;
        endcase
    end
end

assign g[0] = (state == 2'b01); // Grant for device 0
assign g[1] = (state == 2'b10); // Grant for device 1
assign g[2] = (state == 2'b11); // Grant for device 2

endmodule