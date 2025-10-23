module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

// Explicit and efficient implementation using always_comb for clarity and potential synthesis optimizations
always_comb begin
    if (a && b) begin
        q = 1'b1;
    end else begin
        q = 1'b0;
    end
end

endmodule