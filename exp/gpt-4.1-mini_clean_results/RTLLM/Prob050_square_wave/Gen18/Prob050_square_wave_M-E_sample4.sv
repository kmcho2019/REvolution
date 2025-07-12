module square_wave (
    input  wire        clk,
    input  wire        rst,       // Active-high asynchronous reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;
    wire count_zero = (count == 8'd0);
    wire freq_zero  = (freq == 8'd0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else begin
            if (freq_zero) begin
                count    <= 8'd0;      // Hold counter at zero if freq = 0
                wave_out <= 1'b0;      // Hold output steady at 0 if freq = 0
            end else if (count_zero) begin
                count    <= freq;      // Reload counter with freq value
                wave_out <= ~wave_out; // Toggle output when count reaches zero
            end else begin
                count <= count - 8'd1; // Decrement counter
            end
        end
    end

endmodule