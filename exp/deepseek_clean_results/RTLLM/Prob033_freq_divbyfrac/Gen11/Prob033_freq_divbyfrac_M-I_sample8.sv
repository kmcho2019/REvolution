module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_a, clk_b;

// Unified counter for 7 cycles (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Primary phase generation (4/3 cycle alternation)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_a <= 1'b0;
    end else begin
        case (counter)
            3'd0: clk_a <= 1'b1;  // Start of 4-clock phase
            3'd2: clk_a <= 1'b0;  // End of first half
            3'd3: clk_a <= 1'b1;  // Start of 3-clock phase
            3'd4: clk_a <= 1'b0;  // End of second half
            default: clk_a <= clk_a;
        endcase
    end
end

// Secondary phase generation (180° shifted)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_b <= 1'b0;
    end else begin
        case (counter)
            3'd0: clk_b <= 1'b1;  // Start of shifted 4-clock phase
            3'd2: clk_b <= 1'b0;  // End of first shifted half
            3'd3: clk_b <= 1'b1;  // Start of shifted 3-clock phase
            3'd4: clk_b <= 1'b0;  // End of second shifted half
            default: clk_b <= clk_b;
        endcase
    end
end

// Final output combination
assign clk_div = clk_a | clk_b;

endmodule