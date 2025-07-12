module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number >=3
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Parameter validation
initial begin
    if (NUM_DIV < 3 || NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number >= 3");
        $finish;
    end
end

localparam CNT_WIDTH = $clog2(NUM_DIV);
localparam TOGGLE_POINT = (NUM_DIV - 1)/2;
reg [CNT_WIDTH-1:0] counter;
wire toggle_rise = (counter == TOGGLE_POINT);
wire toggle_fall = (counter == NUM_DIV - 1);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        clk_div <= 0;
    end else begin
        // Update counter
        if (toggle_fall) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
        
        // Phase-compensated toggle logic
        if (toggle_rise || toggle_fall) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule