module square_wave (
    input  wire       clk,
    input  wire       rst_n,     // Active low synchronous reset
    input  wire [7:0] freq,
    output reg        wave_out
);

    reg [7:0] count;
    wire       count_enable;
    wire       reload;
    
    // Enable counting only if freq != 0
    assign count_enable = (freq != 8'd0);
    // Reload condition: when count reaches zero
    assign reload = count == 8'd0;

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (count_enable) begin
            if (reload) begin
                wave_out <= ~wave_out;
                // Reload counter with freq on toggle
                count <= freq;
            end else begin
                // Count down on each clock cycle
                count <= count - 8'd1;
            end
        end else begin
            // Hold count and output steady when freq = 0
            count <= count;
            wave_out <= wave_out;
        end
    end

endmodule