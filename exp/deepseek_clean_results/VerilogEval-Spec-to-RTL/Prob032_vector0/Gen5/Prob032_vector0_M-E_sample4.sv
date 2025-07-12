module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    reg [2:0] shift_reg;

    always @(*) begin
        shift_reg = vec;  // Parallel load
    end

    // Output individual bits
    assign o2 = shift_reg[2];
    assign o1 = shift_reg[1];
    assign o0 = shift_reg[0];

    // Output the complete vector
    assign outv = shift_reg;

endmodule