module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    localparam integer DIV_TOTAL = 7; // total cycles for multiplication factor (2*3.5)
    
    reg [2:0] count;
    reg       clk_en;

    // Counter counts 0..6 cyclically
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == DIV_TOTAL - 1)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // Generate clock enable pulses spaced unevenly over the 7 cycles.
    // For 3.5 division, toggle output clock on 4 pulses evenly spaced:
    // Enable pulses on counts: 0, 2, 4, 6 (every other cycle)
    // This creates 4 pulses in 7 cycles -> toggle clk_div 4 times every 7 clk cycles.
    always @(*) begin
        case (count)
            3'd0, 3'd2, 3'd4, 3'd6: clk_en = 1'b1;
            default: clk_en = 1'b0;
        endcase
    end

    // Toggle clk_div on each clk_en pulse
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div <= 1'b0;
        else if (clk_en)
            clk_div <= ~clk_div;
        // else retain previous value
    end

endmodule