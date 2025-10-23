module freq_diveven (
    input  clk,    // Input clock signal
    input  rst_n,  // Active-low reset signal
    output reg clk_div  // Divided clock output signal
);

parameter NUM_DIV = 8; // Must be an even number

reg [3:0] cnt; // Counter register
reg enable_div; // Enable signal for divided clock update
reg prev_enable_div; // Previous value of enable_div for edge detection

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        enable_div <= 0;
        prev_enable_div <= 0;
        clk_div <= 0;
    end else begin
        if (cnt == (NUM_DIV / 2 - 1)) begin
            cnt <= 0;
            enable_div <= 1;
        end else begin
            cnt <= cnt + 1;
            enable_div <= 0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_enable_div <= 0;
    end else begin
        prev_enable_div <= enable_div;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 0;
    end else if (enable_div && !prev_enable_div) begin
        clk_div <= !clk_div;
    end
end

endmodule