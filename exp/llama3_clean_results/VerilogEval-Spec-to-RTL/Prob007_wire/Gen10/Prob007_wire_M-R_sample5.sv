module TopModule(
    input  logic in,
    output logic out
);
    // Using an always block to assign the input to the output
    always @(in) begin
        out = in;
    end
endmodule