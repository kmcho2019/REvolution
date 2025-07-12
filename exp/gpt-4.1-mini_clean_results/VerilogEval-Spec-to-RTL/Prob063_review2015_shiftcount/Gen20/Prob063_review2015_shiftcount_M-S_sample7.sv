module TopModule (
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena)
            q <= {q[2:0], data};      // Shift left, MSB first, input at LSB
        else if (count_ena)
            q <= q - 1;              // Decrement modulo 16
        // else hold q
    end

endmodule