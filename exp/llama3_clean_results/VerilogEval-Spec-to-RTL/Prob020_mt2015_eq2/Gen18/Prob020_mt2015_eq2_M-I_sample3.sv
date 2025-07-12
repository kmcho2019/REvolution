module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

always_comb begin
    // Direct comparison for simplicity and efficiency
    z = (A == B);
end

// Optional output buffering for improved driving capability
// This might not be necessary in all cases and depends on the specific requirements and target hardware
// assign z_buffered = z;

endmodule