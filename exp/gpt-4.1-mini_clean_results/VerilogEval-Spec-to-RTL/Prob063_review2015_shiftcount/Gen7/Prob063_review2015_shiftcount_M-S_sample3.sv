module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena)
            q <= {data, q[3:1]};      // Shift in MSB, shift bits toward LSB
        else if (count_ena)
            q <= q - 4'd1;            // Decrement with wrap-around
        else
            q <= q;                   // Hold current value
    end

endmodule