module square_wave (
    input wire clk,
    input wire [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;

    initial begin
        wave_out = 1'b0;
        count = 8'd0;
    end

    always @(posedge clk) begin
        if (freq == 8'd0) begin
            // When freq=0, hold counter and output steady to save power
            count <= 8'd0;
            wave_out <= wave_out;
        end else if (count == freq - 1) begin
            count <= 8'd0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 1;
        end
    end

endmodule