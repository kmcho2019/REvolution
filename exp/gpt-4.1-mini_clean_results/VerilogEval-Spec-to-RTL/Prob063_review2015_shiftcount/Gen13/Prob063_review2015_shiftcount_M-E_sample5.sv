module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift right: MSB gets 'data', LSB is discarded
            q <= {data, q[3:1]};
        end else if (count_ena) begin
            q <= q - 1;
        end else begin
            q <= q; // Hold current value
        end
    end

endmodule