module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg main_pulse;
reg correction_pulse;
reg toggle_out;

// Counter and pulse generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        main_pulse <= 1'b0;
    end
    else begin
        // Update counter (0-6)
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
        
        // Generate main pulse at count 0 (positive edge)
        main_pulse <= (counter == 3'd0);
    end
end

// Generate correction pulse at count 3 (negative edge)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        correction_pulse <= 1'b0;
    end
    else begin
        correction_pulse <= (counter == 3'd3);
    end
end

// Combine pulses and toggle output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        toggle_out <= 1'b0;
    end
    else if (main_pulse || correction_pulse) begin
        toggle_out <= ~toggle_out;
    end
end

assign clk_div = toggle_out;

endmodule