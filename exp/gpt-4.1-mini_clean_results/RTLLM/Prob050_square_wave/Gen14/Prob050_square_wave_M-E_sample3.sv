module square_wave (
    input  wire        clk,
    input  wire        rst_n,     // Active-low asynchronous reset
    input  wire [7:0]  freq,      // Frequency control (toggle period)
    output reg         wave_out
);

    reg [7:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter  <= 8'd0;
            wave_out <= 1'b0;
        end else if (freq == 8'd0) begin
            // Hold output steady and do not count when freq=0
            counter  <= 8'd0;
            wave_out <= wave_out;
        end else if (counter == 8'd0) begin
            // Toggle output and reload counter with freq - 1
            wave_out <= ~wave_out;
            counter  <= freq - 8'd1;
        end else begin
            // Decrement counter
            counter <= counter - 8'd1;
        end
    end

endmodule