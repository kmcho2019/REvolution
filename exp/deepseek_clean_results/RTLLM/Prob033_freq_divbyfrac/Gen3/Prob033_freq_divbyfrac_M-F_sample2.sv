module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] pos_counter;
reg [2:0] neg_counter;
reg clk_pos;
reg clk_neg;

// Positive edge counter (4 high, 3 low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pos_counter <= 3'b0;
        clk_pos <= 1'b0;
    end else begin
        if (pos_counter == 3'd6) begin
            pos_counter <= 3'b0;
        end else begin
            pos_counter <= pos_counter + 1'b1;
        end
        
        clk_pos <= (pos_counter < 3'd4);
    end
end

// Negative edge counter (3 high, 4 low) - phase shifted
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        neg_counter <= 3'd3; // Start at different phase
        clk_neg <= 1'b0;
    end else begin
        if (neg_counter == 3'd6) begin
            neg_counter <= 3'b0;
        end else begin
            neg_counter <= neg_counter + 1'b1;
        end
        
        clk_neg <= (neg_counter < 3'd3);
    end
end

// Combine both phase-shifted clocks
assign clk_div = clk_pos | clk_neg;

endmodule