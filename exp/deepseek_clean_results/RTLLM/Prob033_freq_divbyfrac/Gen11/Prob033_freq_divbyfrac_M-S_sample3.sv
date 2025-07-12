module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Counter for 3.5x division (7 half-cycles)
reg [2:0] cnt;

always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b0;
        clk_div <= 1'b0;
    end else begin
        // Increment counter on both edges
        cnt <= (cnt == 6) ? 3'b0 : cnt + 1'b1;
        
        // Generate output waveform directly
        case (cnt)
            0,1,2,3: clk_div <= 1'b1;  // 4 half-cycles high
            4,5,6:   clk_div <= 1'b0;   // 3 half-cycles low
            default: clk_div <= 1'b0;
        endcase
    end
end

endmodule