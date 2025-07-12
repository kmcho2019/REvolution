module square_wave (
    input wire clk,
    input wire [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;

    // On reset, initialize wave_out; no async reset specified, so initialize at declaration
    initial begin
        wave_out = 1'b0;
        count = 8'd0;
    end

    always @(posedge clk) begin
        if (freq <= 1) begin
            // If freq=0: hold wave_out steady (no toggling)
            // If freq=1: toggle wave_out every clock cycle
            count <= 8'd0;
            if (freq == 1)
                wave_out <= ~wave_out;
            else
                wave_out <= wave_out;
        end else begin
            // Increment count; wrap when count reaches freq-1
            if (count == freq - 1) begin
                count <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule