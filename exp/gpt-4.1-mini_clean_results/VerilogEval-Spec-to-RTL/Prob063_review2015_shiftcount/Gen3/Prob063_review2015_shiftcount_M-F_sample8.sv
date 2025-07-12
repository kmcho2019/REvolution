module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift data into MSB, shift bits right towards LSB explicitly
            q[3] <= data;
            q[2] <= q[3];
            q[1] <= q[2];
            q[0] <= q[1];
        end else if (count_ena) begin
            // Decrement the register value
            q <= q - 4'd1;
        end
        // else hold q
    end

endmodule