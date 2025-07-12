module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // Current state

// Combinational logic for next state
always_comb begin
    case (y)
        3'b000: y = (x == 0) ? 3'b000 : 3'b001;
        3'b001: y = (x == 0) ? 3'b001 : 3'b100;
        3'b010: y = (x == 0) ? 3'b010 : 3'b001;
        3'b011: y = (x == 0) ? 3'b001 : 3'b010;
        3'b100: y = (x == 0) ? 3'b011 : 3'b100;
        default: y = 3'b000; // Don't care states default to 000
    endcase
end

// Combinational logic for output
assign z = (y == 3'b011 || y == 3'b100) ? 1 : 0;

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to state 000
        y <= 3'b000;
    end else begin
        y <= y;
    end
end

endmodule