module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;

    always @(posedge clk) begin
        if (freq == 8'd0) begin
            // Freeze output when frequency is zero
            count <= 8'd0;
        end
        else if (count == (freq - 1)) begin
            // Normal operation: toggle and reset
            count <= 8'd0;
            wave_out <= ~wave_out;
        end
        else begin
            // Increment counter
            count <= count + 8'd1;
        end
    end

endmodule