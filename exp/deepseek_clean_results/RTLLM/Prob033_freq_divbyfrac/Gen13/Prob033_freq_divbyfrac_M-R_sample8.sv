module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
wire phase_a, phase_b;

// Counter logic (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Phase generation (combinatorial)
assign phase_a = (counter < 3'd4);  // High for 4 cycles (0-3)
assign phase_b = (counter >= 3'd4); // High for 3 cycles (4-6)

// Phase-shifted versions
reg phase_a_shifted, phase_b_shifted;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a_shifted <= 1'b0;
    end else begin
        phase_a_shifted <= phase_a;
    end
end

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b_shifted <= 1'b0;
    end else begin
        phase_b_shifted <= phase_b;
    end
end

// Final output combination
assign clk_div = phase_a_shifted | phase_b_shifted;

endmodule