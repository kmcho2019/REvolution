module square_wave (
    input        clk,
    input        rst_n,
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire [7:0] terminal_count = freq - 8'd1;
    wire       enable_count = (freq != 8'd0);

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (enable_count) begin
            if (count == terminal_count) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1'b1;
            end
        end else begin
            count <= count;       // Hold count to reduce toggling
            wave_out <= wave_out; // Hold wave_out steady when freq=0
        end
    end

endmodule