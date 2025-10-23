module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    reg [31:0] counter;
    localparam HALF_CYCLE = (NUM_DIV - 1) / 2;

    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_div <= 0;
        end else begin
            if (counter == HALF_CYCLE) begin
                clk_div <= ~clk_div;
                counter <= counter + 1;
            end else if (counter == (NUM_DIV - 1)) begin
                clk_div <= ~clk_div;
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule