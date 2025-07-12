module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    localparam CNT_WIDTH = $clog2(NUM_DIV);
    localparam HALF_CYCLE = (NUM_DIV - 1) / 2;
    
    reg [CNT_WIDTH-1:0] counter;
    wire counter_max = (counter == NUM_DIV - 1);
    
    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_div <= 0;
        end
        else begin
            if (counter_max) begin
                counter <= 0;
            end
            else begin
                counter <= counter + 1;
            end
            
            // Toggle at half cycle points
            if (counter == HALF_CYCLE - 1) begin
                clk_div <= 1;
            end
            else if (counter_max) begin
                clk_div <= 0;
            end
        end
    end

endmodule