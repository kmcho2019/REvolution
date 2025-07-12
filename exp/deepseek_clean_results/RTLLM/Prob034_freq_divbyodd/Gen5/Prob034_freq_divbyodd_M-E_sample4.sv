module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameter validation
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

reg [31:0] counter;
wire [31:0] half_period = (NUM_DIV - 1) >> 1;  // Exact midpoint
reg rise_pulse, fall_pulse;
reg sr_set, sr_reset;

// Main counter - increments on rising edge only
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
    end else begin
        if (counter == NUM_DIV - 1)
            counter <= 0;
        else
            counter <= counter + 1;
    end
end

// Rising edge pulse generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rise_pulse <= 0;
    end else begin
        rise_pulse <= (counter == half_period);
    end
end

// Falling edge pulse generation
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fall_pulse <= 0;
    end else begin
        fall_pulse <= (counter == NUM_DIV - 1);
    end
end

// Combine pulses to generate set/reset signals
always @(*) begin
    sr_set = rise_pulse;
    sr_reset = fall_pulse;
end

// SR latch for glitch-free output
reg clk_div_reg;
always @(*) begin
    if (sr_set)
        clk_div_reg = 1'b1;
    else if (sr_reset)
        clk_div_reg = 1'b0;
end

assign clk_div = clk_div_reg;

endmodule