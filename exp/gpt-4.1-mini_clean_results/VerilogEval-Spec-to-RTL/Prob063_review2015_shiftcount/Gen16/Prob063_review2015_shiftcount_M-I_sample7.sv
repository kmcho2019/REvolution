module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift left by 1 bit (MSB-first): bits move towards MSB, input data at LSB
            q <= {q[2:0], data};
        end else if (count_ena) begin
            // Decrement the 4-bit register by 1 using arithmetic subtraction
            q <= q - 1;
        end
        // No reset or other conditions as per specification
    end

endmodule