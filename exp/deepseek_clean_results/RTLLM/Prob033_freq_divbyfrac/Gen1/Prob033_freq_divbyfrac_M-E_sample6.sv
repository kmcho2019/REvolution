module freq_divbyfrac (
    input clk,
    input rst_n,
    output reg clk_div
);

reg [2:0] pos_counter;
reg [2:0] neg_counter;
wire pos_edge_pulse;
wire neg_edge_pulse;
reg phase_shift;

// Positive edge counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pos_counter <= 3'b000;
    end else begin
        pos_counter <= (pos_counter == 3'b110) ? 3'b000 : pos_counter + 1;
    end
end

// Negative edge counter (0-6)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        neg_counter <= 3'b000;
        phase_shift <= 1'b0;
    end else begin
        neg_counter <= (neg_counter == 3'b110) ? 3'b000 : neg_counter + 1;
        phase_shift <= ~phase_shift;
    end
end

// Rising edge generation (at 0 and 3.5 cycles)
assign pos_edge_pulse = (pos_counter == 3'b000) || 
                       ((pos_counter == 3'b011) && phase_shift);

// Falling edge generation (at 1.75 and 5.25 cycles)
assign neg_edge_pulse = ((neg_counter == 3'b001) && !phase_shift) || 
                        ((neg_counter == 3'b100) && phase_shift);

// Output clock generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end else if (pos_edge_pulse) begin
        clk_div <= 1'b1;
    end
end

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end else if (neg_edge_pulse) begin
        clk_div <= 1'b0;
    end
end

endmodule