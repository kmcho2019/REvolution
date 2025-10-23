module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6;  // Must be even number
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be an even number");
        $finish;
    end
end

localparam CNT_WIDTH = $clog2(NUM_DIV);
localparam TOGGLE_VALUE = (NUM_DIV/2) - 1;

// Gray-coded counter for low power
reg [CNT_WIDTH-1:0] cnt;
reg [CNT_WIDTH-1:0] cnt_gray;
wire cnt_toggle = (cnt == TOGGLE_VALUE);

// Synchronize reset
reg rst_n_sync1, rst_n_sync2;
always @(posedge clk) begin
    rst_n_sync1 <= rst_n;
    rst_n_sync2 <= rst_n_sync1;
end

always @(posedge clk or negedge rst_n_sync2) begin
    if (!rst_n_sync2) begin
        cnt <= 0;
        cnt_gray <= 0;
        clk_div <= 1'b0;
    end else begin
        // Binary counter
        if (cnt == NUM_DIV-1)
            cnt <= 0;
        else
            cnt <= cnt + 1;
            
        // Gray code conversion
        cnt_gray <= cnt ^ (cnt >> 1);
        
        // Toggle output at mid-point
        if (cnt_toggle)
            clk_div <= ~clk_div;
    end
end

endmodule