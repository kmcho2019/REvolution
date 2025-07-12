module square_wave (
    input  wire       clk,
    input  wire       rst,       // Active high synchronous reset
    input  wire [7:0] freq,
    output reg        wave_out
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (rst) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (freq == 8'd0) begin
            // Hold outputs steady when freq=0
            count    <= count;
            wave_out <= wave_out;
        end else begin
            if (count == 8'd0) begin
                count    <= freq;
                wave_out <= ~wave_out;
            end else begin
                count <= count - 8'd1;
            end
        end
    end

endmodule