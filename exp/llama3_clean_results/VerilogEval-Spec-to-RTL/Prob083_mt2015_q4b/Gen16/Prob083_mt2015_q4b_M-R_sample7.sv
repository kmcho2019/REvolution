module TopModule(
    input x,
    input y,
    output logic z
);
    always @(*) begin
        // Compute z based on x and y using the same logic as ~(x ^ y)
        z = ~(x ^ y);
    end
endmodule