module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Parameters for 3.5x division (7 cycles total)
localparam DIV_HIGH = 4;  // 4 cycles high
localparam DIV_LOW  = 3;  // 3 cycles low
localparam DIV_TOTAL = DIV_HIGH + DIV_LOW;

// State tracking
reg [2:0] state;
wire [2:0] next_state = (state == DIV_TOTAL-1) ? 3'b0 : state + 1'b1;

// Phase clock generation
wire clk_0 = (state < DIV_HIGH);
wire clk_180 = ((state + DIV_HIGH) < DIV_TOTAL);

// Combined clock output
wire clk_div_next = clk_0 | clk_180;

// State and output update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 3'b0;
        clk_div <= 1'b0;
    end else begin
        state <= next_state;
        clk_div <= clk_div_next;
    end
end

endmodule