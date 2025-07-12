module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    wire counter_zero = (count == 8'd0);
    wire [7:0] next_count = counter_zero ? (freq - 8'd1) : (count - 8'd1);

    // Counter update logic
    always @(posedge clk) begin
        count <= next_count;
    end

    // Wave toggle logic
    always @(posedge clk) begin
        if (counter_zero) begin
            wave_out <= ~wave_out;
        end
    end

endmodule