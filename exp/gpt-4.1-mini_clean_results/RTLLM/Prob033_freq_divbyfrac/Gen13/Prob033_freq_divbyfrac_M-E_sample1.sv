module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    reg [2:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 3'd0;
            clk_div <= 1'b0;
        end else begin
            if (counter == 3'd6)
                counter <= 3'd0;
            else
                counter <= counter + 3'd1;

            // Toggle clk_div at counts 3 and 6 to produce fractional divide by 3.5
            if (counter == 3'd3 || counter == 3'd6)
                clk_div <= ~clk_div;
        end
    end

endmodule