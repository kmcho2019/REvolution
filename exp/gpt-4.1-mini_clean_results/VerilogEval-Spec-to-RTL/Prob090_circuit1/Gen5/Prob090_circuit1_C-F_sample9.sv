module TopModule (
    input  logic a,
    input  logic b,
    output logic q
);
    // Combinational logic implemented using always_comb block and logic type:
    // Output q is assigned as the logical AND of inputs a and b.
    always_comb begin
        q = a & b;
    end
endmodule