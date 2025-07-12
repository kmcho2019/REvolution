// Module TopModule implements a 2-1 multiplexer using bitwise operations and a loop.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use a reg to store the output value
reg [99:0] out_reg;

// Always block to handle the combinational logic
always @(*) begin
    // Initialize the output register
    out_reg = 0;
    
    // Loop over each bit position in the input vectors
    for (int i = 0; i < 100; i++) begin
        // Use bitwise operations to select the appropriate bit based on 'sel'
        if (sel) begin
            // If 'sel' is 1, select the bit from 'b'
            out_reg[i] = b[i];
        end else begin
            // If 'sel' is 0, select the bit from 'a'
            out_reg[i] = a[i];
        end
    end
    
    // Assign the output register value to the output port
    out = out_reg;
end

endmodule