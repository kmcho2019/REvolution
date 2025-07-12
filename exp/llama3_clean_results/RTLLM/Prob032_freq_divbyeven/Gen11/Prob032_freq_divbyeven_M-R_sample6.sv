// Refactored frequency divider module
module freq_diveven (
    input  wire clk,    // Input clock signal
    input  wire rst_n,  // Active-low reset signal
    output reg  clk_div  // Divided clock output signal
);

parameter NUM_DIV = 8; // Must be an even number

reg [3:0] cnt;

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;
    end else if (cnt < (NUM_DIV / 2 - 1)) begin
        cnt <= cnt + 1;
    end else begin
        cnt <= 4'd0;
    end
end

// Clock divider logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        clk_div <= ~clk_div;
    end
end

endmodule