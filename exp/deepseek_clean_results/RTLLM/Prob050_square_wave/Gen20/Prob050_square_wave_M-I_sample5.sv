module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    reg gated_clk;

    // Clock gating for freq=0 case
    always @(*) begin
        gated_clk = (freq != 0) ? clk : 1'b0;
    end

    always @(posedge gated_clk) begin
        if (count == freq - 1) begin
            count <= 8'd0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 1;
        end
    end

    // Force output to 0 when freq=0
    always @(posedge clk) begin
        if (freq == 0) begin
            wave_out <= 1'b0;
        end
    end

endmodule