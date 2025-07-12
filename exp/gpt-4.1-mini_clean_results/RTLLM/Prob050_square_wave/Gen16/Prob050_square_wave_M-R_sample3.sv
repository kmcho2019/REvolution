module square_wave (
    input        clk,
    input        rst_n,     // Active low synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    reg [7:0] next_count;
    reg       next_wave_out;
    wire      enable;

    assign enable = (freq != 8'd0);

    always @(*) begin
        if (!enable) begin
            // Hold count and wave_out steady when disabled
            next_count = 8'd0;
            next_wave_out = wave_out;
        end else if (count == freq - 1) begin
            // When count reaches freq-1, reset count and toggle output
            next_count = 8'd0;
            next_wave_out = ~wave_out;
        end else begin
            // Otherwise increment count, hold wave_out
            next_count = count + 1'b1;
            next_wave_out = wave_out;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            count <= 8'd0;
            wave_out <= 1'b0;
        end else begin
            count <= next_count;
            wave_out <= next_wave_out;
        end
    end

endmodule