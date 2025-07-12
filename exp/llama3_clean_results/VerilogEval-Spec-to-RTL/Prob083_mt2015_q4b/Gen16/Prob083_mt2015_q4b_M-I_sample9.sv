module TopModule(
    input x,
    input y,
    output reg z
);
    always @(*) begin
        z = ~(x ^ y); // Direct logical expression for the required functionality
    end
endmodule