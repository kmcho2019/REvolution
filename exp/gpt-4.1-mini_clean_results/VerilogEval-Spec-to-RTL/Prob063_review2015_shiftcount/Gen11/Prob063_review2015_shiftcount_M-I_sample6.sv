module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    wire gated_clk = clk & (shift_ena | count_ena);

    always @(posedge gated_clk) begin
        if (shift_ena) begin
            q <= {data, q[3:1]};  // Shift right, input data at MSB
        end
        else if (count_ena) begin
            q <= q - 1;
        end
        // else retain q as is (no clock pulse, so no change)
    end

endmodule