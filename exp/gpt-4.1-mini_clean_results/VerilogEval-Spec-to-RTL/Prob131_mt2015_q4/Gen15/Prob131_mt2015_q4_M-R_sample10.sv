// Module A: z = (x ^ y) & x using combinational always block
module A(input wire x, input wire y, output reg z);
    always @(*) begin
        z = (x ^ y) & x;
    end
endmodule

// Module B: z = ~(x ^ y) using combinational always block
module B(input wire x, input wire y, output reg z);
    always @(*) begin
        z = ~(x ^ y);
    end
endmodule

// Top-level module with reorganized structure and explicit intermediate wires
module TopModule(input wire x, input wire y, output wire z);
    wire a1_out, a2_out;
    wire b1_out, b2_out;
    wire or_out, and_out;

    // Instantiate submodules
    A A1(.x(x), .y(y), .z(a1_out));
    A A2(.x(x), .y(y), .z(a2_out));
    B B1(.x(x), .y(y), .z(b1_out));
    B B2(.x(x), .y(y), .z(b2_out));

    // Combine outputs with explicit assign statements
    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;

    // Final output is XOR of OR and AND results
    assign z = or_out ^ and_out;
endmodule