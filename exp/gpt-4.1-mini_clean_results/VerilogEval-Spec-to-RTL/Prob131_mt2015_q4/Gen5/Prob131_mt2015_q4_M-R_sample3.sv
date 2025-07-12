// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: output matches simulation waveform, i.e., XNOR function
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module using always_comb procedural assignments for combinational logic
module TopModule(input wire x, input wire y, output reg z);
    wire a_out, b_out;
    reg or_out, and_out;

    // Instantiate single instances of modules A and B
    A a_inst(.x(x), .y(y), .z(a_out));
    B b_inst(.x(x), .y(y), .z(b_out));

    // Compute OR and AND outputs in always_comb blocks to illustrate procedural combinational style
    always @* begin
        or_out = a_out | b_out;
        and_out = a_out & b_out;
    end

    // Compute final output z as XOR of or_out and and_out in always_comb
    always @* begin
        z = or_out ^ and_out;
    end
endmodule