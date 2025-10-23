module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y; // Current state
reg [2:0] next_y; // Next state

// Combinational logic to determine the next state
always @(*)
begin
    case(y)
        3'b000: next_y = x ? 3'b001 : 3'b000;
        3'b001: next_y = x ? 3'b100 : 3'b001;
        3'b010: next_y = x ? 3'b001 : 3'b010;
        3'b011: next_y = x ? 3'b010 : 3'b001;
        3'b100: next_y = x ? 3'b100 : 3'b011;
        default: next_y = 3'b000; // Default to state 000 if current state is unknown
    endcase
end

// Sequential logic to update the current state
always @(posedge clk)
begin
    if (reset) // Synchronous reset
        y <= 3'b000;
    else
        y <= next_y;
end

// Combinational logic to determine the output z
always @(*)
begin
    case(y)
        3'b000, 3'b001, 3'b010: z = 1'b0;
        3'b011, 3'b100: z = 1'b1;
        default: z = 1'b0; // Default output if current state is unknown
    endcase
end

endmodule