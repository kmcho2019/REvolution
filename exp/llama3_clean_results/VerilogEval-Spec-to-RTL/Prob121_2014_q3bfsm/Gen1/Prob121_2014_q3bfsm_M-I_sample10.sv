module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y, next_y;

// State transition logic
always @(*) begin
    case (y)
        3'b000: next_y = (x) ? 3'b001 : 3'b000; // Stay in reset state or move to state 1
        3'b001: next_y = (x) ? 3'b100 : 3'b001; // Move to state 4 or stay
        3'b010: next_y = (x) ? 3'b001 : 3'b010; // Move back to state 1 or stay
        3'b011: next_y = (x) ? 3'b010 : 3'b001; // Move to state 2 or back to state 1
        3'b100: next_y = (x) ? 3'b100 : 3'b011; // Stay or move to state 3
        default: next_y = 3'b000; // Default to reset state
    endcase
end

// Output logic simplified to reduce area and power
always @(*) begin
    case (y)
        3'b011, 3'b100: z = 1; // Only two states produce output 1
        default: z = 0;
    endcase
end

// Sequential logic remains largely the same for simplicity and reliability
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // Synchronous reset to state 0
    end else begin
        y <= next_y; // Update state on clock edge
    end
end

endmodule