module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameter validation
generate
    if (NUM_DIV % 2 == 0) begin
        initial begin
            $error("NUM_DIV must be an odd number");
            $finish;
        end
    end
endgenerate

// Calculate counter width needed
localparam CNT_WIDTH = $clog2(NUM_DIV);
localparam TOGGLE_POINT = (NUM_DIV - 1) / 2;

// Rising edge counter and clock
reg [CNT_WIDTH-1:0] cnt_pos;
reg clk_pos;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_pos <= 0;
        clk_pos <= 0;
    end else begin
        if (cnt_pos == NUM_DIV - 1) begin
            cnt_pos <= 0;
        end else begin
            cnt_pos <= cnt_pos + 1;
        end
        
        if (cnt_pos == TOGGLE_POINT || cnt_pos == NUM_DIV - 1) begin
            clk_pos <= ~clk_pos;
        end
    end
end

// Falling edge counter and clock
reg [CNT_WIDTH-1:0] cnt_neg;
reg clk_neg;

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_neg <= 0;
        clk_neg <= 0;
    end else begin
        if (cnt_neg == NUM_DIV - 1) begin
            cnt_neg <= 0;
        end else begin
            cnt_neg <= cnt_neg + 1;
        end
        
        if (cnt_neg == TOGGLE_POINT || cnt_neg == NUM_DIV - 1) begin
            clk_neg <= ~clk_neg;
        end
    end
end

// Combine both edge clocks
assign clk_div = clk_pos | clk_neg;

endmodule