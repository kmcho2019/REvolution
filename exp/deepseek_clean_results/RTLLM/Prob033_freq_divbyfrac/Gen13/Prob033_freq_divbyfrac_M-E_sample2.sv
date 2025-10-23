module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] phase_counter;
reg [1:0] cycle_selector;
reg clk_3x, clk_4x;
reg delayed_pulse;

// Phase accumulator and cycle selector
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_counter <= 3'b0;
        cycle_selector <= 2'b0;
    end else begin
        phase_counter <= (phase_counter == 3'd6) ? 3'b0 : phase_counter + 1;
        cycle_selector <= (phase_counter == 3'd6) ? ~cycle_selector : cycle_selector;
    end
end

// 3x clock generator
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_3x <= 1'b0;
    end else begin
        if (phase_counter == 3'd0 || phase_counter == 3'd3) begin
            clk_3x <= ~clk_3x;
        end
    end
end

// 4x clock generator with phase shift
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_4x <= 1'b0;
        delayed_pulse <= 1'b0;
    end else begin
        if (phase_counter == 3'd1 || phase_counter == 3'd5) begin
            clk_4x <= ~clk_4x;
        end
        delayed_pulse <= clk_4x;
    end
end

// Output mux with glitch filtering
assign clk_div = (cycle_selector[0]) ? (clk_3x | delayed_pulse) : 
                                     (clk_4x | (delayed_pulse & clk_3x));

endmodule