module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (freq == 8'd0) begin
            // Handle zero frequency case (constant output)
            wave_out <= 1'b0;
            count <= 8'd0;
        end
        else if (count == 8'd1) begin
            // Toggle output and reload counter
            wave_out <= ~wave_out;
            count <= freq;
        end
        else begin
            // Decrement counter
            count <= count - 1'b1;
        end
    end

endmodule