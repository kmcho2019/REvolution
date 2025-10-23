module TopModule(
    input  clk,
    input  reset,
    input  x,
    output reg z
);

reg [2:0] y;  // Current state
reg [2:0] next_y;  // Next state

// Determine next state
always @(*) begin
    case (y)
        3'b000: next_y = (x) ? 3'b001 : 3'b000;
        3'b001: next_y = (x) ? 3'b100 : 3'b001;
        3'b010: next_y = (x) ? 3'b001 : 3'b010;
        3'b011: next_y = (x) ? 3'b010 : 3'b001;
        3'b100: next_y = (x) ? 3'b100 : 3'b011;
        default: next_y = 3'b000;  // Default next state
    endcase
end

// Determine output z
always @(*) begin
    case (y)
        3'b000, 3'b001, 3'b010: z = 0;
        3'b011, 3'b100: z = 1;
        default: z = 0;  // Default output
    endcase
end

// Update state register on positive edge of clock
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;  // Synchronous reset to state 000
    end else begin
        y <= next_y;
    end
end

endmodule