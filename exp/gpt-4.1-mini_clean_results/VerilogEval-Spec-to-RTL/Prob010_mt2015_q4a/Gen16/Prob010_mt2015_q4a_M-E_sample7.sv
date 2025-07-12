module TopModule (
    input  wire x,
    input  wire y,
    output reg  z
);

    // Intermediate signals to hold partial computations
    reg xor_result;

    // Combinational logic block computing the function stepwise
    always @(*) begin
        xor_result = x ^ y;
        z = xor_result & x;
    end

endmodule