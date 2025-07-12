module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state; // State can be 0, 1, or 2 (for A, B, C respectively)

always @(posedge clk) begin
    if (~resetn) state <= 2'b00; // Reset to state A
    else begin
        case (state)
            2'b00: begin // State A
                if (r[0]) state <= 2'b01; // If r[0] is high, go to state B
                else if (r[1]) state <= 2'b10; // If r[1] is high, go to state C
                else if (r[2]) state <= 2'b11; // If r[2] is high, go to state D
            end
            2'b01: if (!r[0]) state <= 2'b00; // State B
            2'b10: if (!r[1]) state <= 2'b00; // State C
            2'b11: if (!r[2]) state <= 2'b00; // State D
        endcase
    end
end

assign g[0] = (state == 2'b01); // g[0] is high in state B
assign g[1] = (state == 2'b10); // g[1] is high in state C
assign g[2] = (state == 2'b11); // g[2] is high in state D

endmodule