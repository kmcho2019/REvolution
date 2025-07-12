module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_div1;
reg clk_div2;
reg clk_div2_delayed;

// Main counter and first divided clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        clk_div1 <= 1'b0;
    end else begin
        // Cycle through 0-6 (7 counts)
        if (counter == 3'd6)
            counter <= 3'b0;
        else
            counter <= counter + 1'b1;
        
        // Toggle pattern: 3 cycles low, 4 cycles high
        case (counter)
            3'd2: clk_div1 <= 1'b1;
            3'd6: clk_div1 <= 1'b0;
            default: clk_div1 <= clk_div1;
        endcase
    end
end

// Generate phase-shifted version (180° shifted)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div2 <= 1'b0;
    end else begin
        // Same toggle pattern as clk_div1 but offset
        case (counter)
            3'd2: clk_div2 <= 1'b1;
            3'd6: clk_div2 <= 1'b0;
            default: clk_div2 <= clk_div2;
        endcase
    end
end

// Combine both phases with proper alignment
assign clk_div = clk_div1 | clk_div2;

endmodule