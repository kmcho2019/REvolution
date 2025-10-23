module TopModule(x, y, z);
    input x, y;
    output z;

    wire x_y_diff; // Indicates if x and y are different
    wire x_y_same; // Indicates if x and y are the same
    wire a_out;    // Output of ModuleA-like condition
    wire b_out;    // Output of ModuleB-like condition
    wire or_out;   // Output of OR gate combining first pair of submodules
    wire and_out;  // Output of AND gate combining second pair of submodules

    // Check if x and y are different
    XOR diff_gate(x, y, x_y_diff);

    // Check if x and y are the same
    XNOR same_gate(x, y, x_y_same);

    // Implement ModuleA-like condition: x is true and x and y are different
    AND a_condition(x, x_y_diff, a_out);

    // Implement ModuleB-like condition: x and y are the same
    BUF b_condition(same_gate, b_out);

    // First pair of submodules connected to an OR gate
    OR or_gate(a_out, b_out, or_out);

    // Second pair of submodules connected to an AND gate
    AND and_gate(a_out, b_out, and_out);

    // Final output is XOR of OR and AND outputs
    XOR final_xor(or_out, and_out, z);
endmodule