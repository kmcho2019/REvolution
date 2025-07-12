module square_wave (
    input        clk,
    input        rst_n,       // Active low synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire      active;         // Enable counting and toggling only when freq != 0

    assign active = (freq != 8'd0);

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (active) begin
            if (count == 8'd0) begin
                count    <= freq;
                wave_out <= ~wave_out;
            end else begin
                count <= count - 1'b1;
            end
        end else begin
            count <= 8'd0;       // Hold count at zero when disabled
            // wave_out holds its last state when freq=0
        end
    end

endmodule