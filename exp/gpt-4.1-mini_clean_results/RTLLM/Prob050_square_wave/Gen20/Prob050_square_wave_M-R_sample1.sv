module square_wave (
    input  wire        clk,
    input  wire        rst,       // Active-high synchronous reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (rst) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else begin
            if (freq != 8'd0) begin
                if (count == freq - 1) begin
                    count    <= 8'd0;
                    wave_out <= ~wave_out;
                end else begin
                    count <= count + 8'd1;
                end
            end else begin
                // freq = 0: hold count and wave_out steady
                count    <= count;
                wave_out <= wave_out;
            end
        end
    end

endmodule