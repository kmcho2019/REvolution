module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count;
    wire counter_done = (count == 8'd1);
    wire active = (freq != 8'd0);
    reg next_wave;

    always @(*) begin
        if (!active) begin
            next_wave = 1'b0;
        end else if (counter_done) begin
            next_wave = ~wave_out;
        end else begin
            next_wave = wave_out;
        end
    end

    always @(posedge clk) begin
        wave_out <= next_wave;
        
        if (!active) begin
            count <= 8'd0;
        end else if (counter_done) begin
            count <= freq;
        end else begin
            count <= count - 1;
        end
    end

endmodule