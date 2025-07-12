// Define a parameterized module for the XOR gate
module xor_module #(
    parameter implement_as = "assign" // Can be "assign", "always_comb", or "always_ff"
)(
    input clk,
    input a,
    input b,
    output reg out
);

    if (implement_as == "assign") begin
        assign out = a ^ b;
    end else if (implement_as == "always_comb") begin
        always_comb begin
            out = a ^ b;
        end
    end else if (implement_as == "always_ff") begin
        always_ff @(posedge clk) begin
            out <= a ^ b; // Use non-blocking assignment to prevent race conditions
        end
    end

endmodule

// TopModule implementation
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Instantiate the XOR gate module for assign and combinational always block outputs
    xor_module #(.implement_as("always_comb")) u_comb(
       .clk(1'b0), // Dummy clock for combinational always block implementation
       .a(a),
       .b(b),
       .out(out_always_comb)
    );

    assign out_assign = a ^ b; // Directly implement assign statement

    // Instantiate the XOR gate module for clocked always block output
    xor_module #(.implement_as("always_ff")) u_always_ff(
       .clk(clk),
       .a(a),
       .b(b),
       .out(out_always_ff)
    );

endmodule