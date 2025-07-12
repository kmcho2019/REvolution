module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;

// Dual-edge counter (0-6) for 3.5x division
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else if (clk) begin // posedge
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
    // No action on negedge - counter only advances on posedge
end

// Phase generation using direct assignment
wire phase_a = (counter < 3'd4) && (counter != 3'd0 || rst_n);
wire phase_b = (counter >= 3'd3) && (counter != 3'd6 || rst_n);

// Final output combination
assign clk_div = phase_a | phase_b;

endmodule