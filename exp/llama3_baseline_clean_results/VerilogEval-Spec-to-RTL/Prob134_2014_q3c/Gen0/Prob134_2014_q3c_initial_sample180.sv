module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] present_state;
reg [2:0] next_state;

// Output logic
always @(present_state or x or y) begin
    case(present_state)
        3'b000: z = 0;
        3'b001: z = 0;
        3'b010: z = 0;
        3'b011: z = 1;
        3'b100: z = 1;
        default: z = 0; // Default output when not in specified states
    endcase
end

// Next state logic
always @(present_state or x or y) begin
    case(present_state)
        3'b000: if (!x) next_state = 3'b000; else next_state = 3'b001;
        3'b001: if (!x) next_state = 3'b001; else next_state = 3'b100;
        3'b010: if (!x) next_state = 3'b010; else next_state = 3'b001;
        3'b011: if (!x) next_state = 3'b001; else next_state = 3'b010;
        3'b100: if (!x) next_state = 3'b011; else next_state = 3'b100;
        default: next_state = 3'b000; // Default next state when not in specified states
    endcase
end

// Update present state
always @(posedge clk) begin
    present_state <= next_state;
end

// Assign Y0 as the least significant bit of the next state
assign Y0 = next_state[0];

endmodule