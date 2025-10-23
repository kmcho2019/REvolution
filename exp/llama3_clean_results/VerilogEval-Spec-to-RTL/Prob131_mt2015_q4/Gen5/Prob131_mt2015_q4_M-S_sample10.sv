// Simplified TopModule directly implementing the required logic
module TopModule(x, y, z);
    input x;
    input y;
    output z;

    // Directly calculate the outputs of the A and B modules
    wire a_out = (x ^ y) & x;
    wire b_out = ~(x | y) | (x & y);

    // Calculate the output of the OR and AND gates
    wire or_out = a_out | b_out;
    wire a2_out = (x ^ y) & x;
    wire b2_out = ~(x | y) | (x & y);
    wire and_out = a2_out & b2_out;

    // Final output is the XOR of the OR and AND outputs
    assign z = or_out ^ and_out;
endmodule