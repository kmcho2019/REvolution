module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);
    // Using an always block for combinational logic
    always_comb begin
        out = in;  // Direct assignment within the always block
    end
endmodule