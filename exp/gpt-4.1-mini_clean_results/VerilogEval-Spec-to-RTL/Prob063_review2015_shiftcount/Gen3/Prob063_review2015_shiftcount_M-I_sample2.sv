module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift register shifts right by 1 bit (towards LSB)
            // MSB (q[3]) takes the new 'data' input
            // Bits q[3:1] shift into q[2:0]
            // Thus: q[3] <= data; q[2] <= q[3]; q[1] <= q[2]; q[0] <= q[1];
            q <= {data, q[3:1]};
        end else if (count_ena) begin
            // Decrement the 4-bit register value by 1 with wrap-around
            q <= q - 4'd1;
        end
        // else hold q
    end

endmodule