module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

reg [31:0] counter;
wire counter_half = (counter == ((NUM_DIV - 1) >> 1));
wire counter_full = (counter == (NUM_DIV - 1));

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        clk_div <= 0;
    end
    else begin
        if (counter_full) begin
            counter <= 0;
            clk_div <= ~clk_div;
        end
        else begin
            counter <= counter + 1;
            if (counter_half) begin
                clk_div <= ~clk_div;
            end
        end
    end
end

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset handled in posedge block
    end
    else begin
        if (!counter_full) begin
            counter <= counter + 1;
            if (counter_half) begin
                clk_div <= ~clk_div;
            end
        end
    end
end

endmodule