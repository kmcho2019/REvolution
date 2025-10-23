module square_wave (
    input  wire       clk,
    input  wire       rst,       // Active-high synchronous reset
    input  wire [7:0] freq,
    output reg        wave_out
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (rst) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else begin
            if (count == 8'd0) begin
                // Reload counter with freq if freq > 0, else keep at zero
                if (freq != 8'd0)
                    count <= freq - 8'd1;
                else
                    count <= 8'd0;
                wave_out <= ~wave_out;  // Toggle wave output
            end else begin
                count <= count - 8'd1;  // Decrement counter
            end
        end
    end

endmodule