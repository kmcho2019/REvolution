module TopModule(
    input  logic in,
    output logic out
);
    // Using an always block for the combinational assignment
    always_comb begin
        out = in;
    end
endmodule