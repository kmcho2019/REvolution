module LFSR #(parameter WIDTH = 4) (
    input clk,
    input rst,
    output [WIDTH-1:0] out
);

// Internal flip-flop states
wire [WIDTH-1:0] current_state;
wire [WIDTH-1:0] next_state;

// Feedback calculation
wire feedback;
assign feedback = ~(current_state[WIDTH-1] ^ current_state[WIDTH-2]);

// Next state logic (shift left with feedback)
assign next_state = rst ? {WIDTH{1'b0}} : 
                   {current_state[WIDTH-2:0], feedback};

// Delay elements (D flip-flops)
assign current_state = next_state;

// Output assignment
assign out = current_state;

endmodule