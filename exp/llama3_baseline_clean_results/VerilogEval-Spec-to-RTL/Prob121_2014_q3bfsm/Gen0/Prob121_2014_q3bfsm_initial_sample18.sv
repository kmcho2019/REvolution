module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y; // Current state register
reg [2:0] nxt_y; // Next state register
reg z_reg; // Output register

// State encoding: Not explicitly needed but shown for clarity
// 000, 001, 010, 011, 100 are the states used

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // Synchronous reset to state 000
        z_reg <= 0; // Reset output
    end else begin
        y <= nxt_y;
        z_reg <= (y == 3'b011 || y == 3'b100);
    end
end

always @* begin
    case(y)
        3'b000: nxt_y = (x == 1'b0) ? 3'b000 : 3'b001;
        3'b001: nxt_y = (x == 1'b0) ? 3'b001 : 3'b100;
        3'b010: nxt_y = (x == 1'b0) ? 3'b010 : 3'b001;
        3'b011: nxt_y = (x == 1'b0) ? 3'b001 : 3'b010;
        3'b100: nxt_y = (x == 1'b0) ? 3'b011 : 3'b100;
        default: nxt_y = y; // Default to current state for unmapped states
    endcase
end

assign z = z_reg;

endmodule