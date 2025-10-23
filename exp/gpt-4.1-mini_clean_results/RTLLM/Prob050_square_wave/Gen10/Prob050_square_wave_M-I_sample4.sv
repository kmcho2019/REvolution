module square_wave (
    input        clk,
    input        rst_n,
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    reg [7:0] threshold;

    // Precompute threshold to avoid subtraction inside clocked block
    always @(*) begin
        if (freq != 8'd0)
            threshold = freq - 8'd1;
        else
            threshold = 8'd0;
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (freq != 8'd0) begin
            if (count == threshold) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1'b1;
            end
        end else begin
            count <= 8'd0;      // Freeze count if freq == 0
            wave_out <= wave_out; // Hold wave_out steady
        end
    end

endmodule