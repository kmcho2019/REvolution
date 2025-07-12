module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift left by 1 bit, insert data at MSB (q[3])
            q <= {data, q[3:1]};
        end else if (count_ena) begin
            // Decrement the current value of q by 1
            q <= q - 4'd1;
        end
        // else hold current q value
    end

endmodule