module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    (* optimize_power *)
    (* keep_hierarchy *)
    assign sum = a ^ b;  // Optimal XOR implementation for sum

    (* optimize_power *)
    (* keep_hierarchy *)
    assign cout = a & b; // Optimal AND implementation for carry-out

endmodule