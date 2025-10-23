module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    // Initialize q to zero at simulation start to avoid unknown states
    initial begin
        q = 4'b0000;
    end

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift register: shift right by 1 bit towards LSB
            // Insert new data bit at MSB position q[3]
            // Bits q[3:1] move down to q[2:0]
            // So q[3] <= data
            //    q[2] <= q[3]
            //    q[1] <= q[2]
            //    q[0] <= q[1]
            q <= {data, q[3:1]};
        end else if (count_ena) begin
            // Decrement the 4-bit register value by 1, wraps around naturally
            q <= q - 4'd1;
        end
        // If neither enable is asserted, q holds its value
    end

endmodule