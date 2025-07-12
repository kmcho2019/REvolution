module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

reg [2:0] counter;
reg phase_a, phase_b;

// Counter and phase_a generation (positive edge)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        phase_a <= 1'b0;
    end
    else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
        phase_a <= (counter < 3'd4);
    end
end

// Phase_b generation (negative edge)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end
    else begin
        phase_b <= (counter >= 3'd4);
    end
end

// Combine phases with XOR and register output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end
    else begin
        clk_div <= phase_a ^ phase_b;
    end
end

endmodule