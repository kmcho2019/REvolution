module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // Current state
reg [2:0] next_y; // Next state

always @(*) begin
    case (y)
        3'b000: next_y = (x == 1'b0) ? 3'b000 : 3'b001;
        3'b001: next_y = (x == 1'b0) ? 3'b001 : 3'b100;
        3'b010: next_y = (x == 1'b0) ? 3'b010 : 3'b001;
        3'b011: next_y = (x == 1'b0) ? 3'b001 : 3'b010;
        3'b100: next_y = (x == 1'b0) ? 3'b011 : 3'b100;
        default: next_y = 3'b000; // Default to reset state if invalid state
    endcase
    
    // Determine output z based on current state
    case (y)
        3'b011, 3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // Reset to state 000 on high reset
    end else begin
        y <= next_y; // Update current state on positive edge of clock
    end
end

endmodule