module TopModule(
    input x,
    input y,
    output logic z
);
    always @(*) begin
        // Encapsulating the logic within an always block sensitive to x and y
        z = ~(x ^ y);
    end
endmodule