module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    initial begin
        q = 4'b0000;
    end

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift left, insert data at MSB (bit 3)
            q <= {data, q[3:1]};
        end else if (count_ena) begin
            // Decrement q as a 4-bit down counter
            q <= q - 4'd1;
        end
        // else hold q
    end

endmodule