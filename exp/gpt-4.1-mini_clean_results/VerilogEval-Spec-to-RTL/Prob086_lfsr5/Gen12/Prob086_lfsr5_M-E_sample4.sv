module TopModule(
    input        clk,
    input        reset,
    output reg [4:0] q
);

    wire feedback = q[4] ^ q[2]; // taps at bit 5 (MSB) and bit 3

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            q <= {q[3:0], feedback}; // shift left, insert feedback at LSB
        end
    end

endmodule