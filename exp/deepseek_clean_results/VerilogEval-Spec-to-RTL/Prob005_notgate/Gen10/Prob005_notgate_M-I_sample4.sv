module TopModule (
    input in,
    output out
);
    // Using explicit instantiation of a low-power NOT gate if available in library
    // This would typically be LP_INV or similar in many standard cell libraries
    LP_INV not_gate (
        .A(in),
        .Y(out)
    );
endmodule