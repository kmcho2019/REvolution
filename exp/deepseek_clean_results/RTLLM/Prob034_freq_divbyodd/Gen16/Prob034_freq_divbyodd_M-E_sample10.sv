module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Validate odd division factor
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

reg [NUM_DIV-1:0] phase_reg = 0;
wire phase_pulse = phase_reg[0];
wire mid_phase_pulse = phase_reg[(NUM_DIV-1)/2];

// Circular shift register for phase generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_reg <= {1'b1, {(NUM_DIV-1){1'b0}}};
    end else begin
        phase_reg <= {phase_reg[NUM_DIV-2:0], phase_reg[NUM_DIV-1]};
    end
end

// Toggle flip-flop for output clock generation
reg out_ff;
always @(posedge phase_pulse or posedge mid_phase_pulse or negedge rst_n) begin
    if (!rst_n) begin
        out_ff <= 0;
    end else begin
        out_ff <= ~out_ff;
    end
end

assign clk_div = out_ff;

endmodule