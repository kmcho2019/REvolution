module freq_divbyfrac (
    input  wire clk,     // Input clock
    input  wire rst_n,   // Active low reset
    output reg  clk_div  // Fractionally divided clock output (clk / 3.5)
);

    localparam DIVIDE = 7; // Total count for 3.5 division (2 * 3.5)
    
    // Counter counts from 0 to 6 (mod 7)
    reg [2:0] count;
    
    // Clock enable pattern for toggling clk_div at counts corresponding to half-period edges
    // We want clk_div to toggle at counts: 3 and 0 (mod 7), producing half-periods of length 3 and 4 clk cycles alternately.
    // So CE is 1 at count==3 or count==0, else 0.
    wire clk_div_toggle = (count == 3) || (count == 0);

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 3'd0;
            clk_div <= 1'b0;
        end else begin
            if (clk_div_toggle)
                clk_div <= ~clk_div; // Toggle output clock at defined intervals

            // Increment count modulo DIVIDE
            if (count == (DIVIDE - 1))
                count <= 3'd0;
            else
                count <= count + 3'd1;
        end
    end

endmodule