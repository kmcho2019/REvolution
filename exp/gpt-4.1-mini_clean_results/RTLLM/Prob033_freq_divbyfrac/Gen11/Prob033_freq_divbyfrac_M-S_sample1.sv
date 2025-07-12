module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output reg  clk_div // Fractionally divided output clock (divide by 3.5)
);

    reg [2:0] count;

    // Counter: modulo-7 counting 0..6
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == 3'd6)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // Toggle clk_div at count 0 and 4 to achieve divide-by-3.5
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div <= 1'b0;
        else if (count == 3'd0 || count == 3'd4)
            clk_div <= ~clk_div;
    end

endmodule