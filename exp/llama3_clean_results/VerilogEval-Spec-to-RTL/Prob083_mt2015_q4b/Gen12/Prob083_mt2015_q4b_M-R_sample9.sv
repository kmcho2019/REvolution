module TopModule(
    input x,
    input y,
    output logic z
);
    always_comb begin
        // Assign z based on the equality of x and y
        z = (x == y) ? 1'b1 : 1'b0;
    end
endmodule