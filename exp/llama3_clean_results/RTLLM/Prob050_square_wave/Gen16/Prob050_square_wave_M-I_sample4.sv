module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;

always @(posedge clk) begin
    if (count == freq) begin
        count <= 8'd0;
        wave_out <= !wave_out; // Using ! instead of ~ for simplicity
    end else begin
        count <= count + 8'd1;
    end
end

// However, we can simplify the above code by using a single line for the conditional statement
// and also consider clock gating if the frequency input is rarely changing.
// The simplified version is as follows:

module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;

always @(posedge clk) begin
    count <= (count == freq) ? 8'd0 : count + 8'd1;
    wave_out <= (count == freq) ? !wave_out : wave_out;
end

// Further optimization with clock gating (assuming freq is rarely changing and can be considered a constant for synthesis optimization)
module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;
reg clk_enable;

always @(*) begin
    clk_enable = (count >= (freq - 1)) ? 1'b1 : 1'b0;
end

always @(posedge clk) begin
    if (clk_enable) begin
        count <= (count == freq) ? 8'd0 : count + 8'd1;
        wave_out <= (count == freq) ? !wave_out : wave_out;
    end
end