module square_wave (
    input  wire       clk,
    input  wire       rst,       // Active-high synchronous reset
    input  wire [7:0] freq,
    output reg        wave_out
);

    reg [7:0] count;
    reg [7:0] half_freq;
    wire      count_enable;

    // Enable counting only when freq is nonzero to save power
    assign count_enable = (freq != 8'd0);

    // Register half_freq to reduce combinational logic in comparator
    always @(posedge clk) begin
        if (rst)
            half_freq <= 8'd0;
        else
            half_freq <= freq >> 1;
    end

    // Counter increments only when enabled
    always @(posedge clk) begin
        if (rst)
            count <= 8'd0;
        else if (count_enable) begin
            if (count == freq - 1)
                count <= 8'd0;
            else
                count <= count + 8'd1;
        end else begin
            count <= 8'd0; // hold at zero when disabled
        end
    end

    // Register wave_out on clk rising edge for glitch reduction
    always @(posedge clk) begin
        if (rst)
            wave_out <= 1'b0;
        else if (count_enable) begin
            if (count == freq - 1)
                wave_out <= ~wave_out;
            // else retain wave_out
        end else begin
            wave_out <= 1'b0; // output low when freq=0
        end
    end

endmodule