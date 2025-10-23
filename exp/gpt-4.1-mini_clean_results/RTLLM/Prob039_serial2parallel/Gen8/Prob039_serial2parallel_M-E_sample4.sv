module serial2parallel (
    input        clk,
    input        rst_n,
    input        din_serial,
    input        din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [2:0] bit_count; // counts from 0 to 7

    always @(posedge clk) begin
        if (!rst_n) begin
            dout_parallel <= 8'd0;
            bit_count     <= 3'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default no valid output
            if (din_valid) begin
                dout_parallel[7 - bit_count] <= din_serial; // Assign bit at position
                if (bit_count == 3'd7) begin
                    dout_valid <= 1'b1; // 8 bits collected
                    bit_count  <= 3'd0; // reset for next frame
                end else begin
                    bit_count <= bit_count + 1'b1;
                end
            end
        end
    end

endmodule