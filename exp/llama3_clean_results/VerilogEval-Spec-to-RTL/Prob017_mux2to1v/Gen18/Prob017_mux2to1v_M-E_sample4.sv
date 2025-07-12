// Module TopModule implements a 2-1 multiplexer using tri-state buffers.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    // 100-bit input vectors a and b
    input  [99:0] a,  
    input  [99:0] b,  
    // 1-bit select input sel
    input  sel,       
    // 100-bit output vector out
    output [99:0] out 
);

// Use tri-state buffers to conditionally drive the output 'out'
wire [99:0] out_a;
wire [99:0] out_b;

// Drive 'out_a' with 'a' when 'sel' is 0, otherwise drive with high-Z
assign out_a = (sel == 1'b0) ? a : {100{1'bz}};

// Drive 'out_b' with 'b' when 'sel' is 1, otherwise drive with high-Z
assign out_b = (sel == 1'b1) ? b : {100{1'bz}};

// Use a continuous assignment to drive 'out' with the result of 'out_a' and 'out_b'
assign out = out_a | out_b;

endmodule