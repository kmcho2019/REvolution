module square_wave (
    input        clk,
    input        rst,         // Active high synchronous reset
    input  [7:0] freq,        // Frequency control
    output reg   wave_out
);

    reg [7:0] countdown;

    always @(posedge clk) begin
        if (rst) begin
            countdown <= 8'd0;
            wave_out  <= 1'b0;
        end else if (freq == 8'd0) begin
            // Hold output steady when freq is zero (no toggling)
            countdown <= 8'd0;
            wave_out  <= wave_out;
        end else if (countdown == 8'd0) begin
            // Toggle output and reload countdown
            wave_out  <= ~wave_out;
            countdown <= freq;
        end else begin
            // Decrement countdown each cycle
            countdown <= countdown - 1'b1;
        end
    end

endmodule