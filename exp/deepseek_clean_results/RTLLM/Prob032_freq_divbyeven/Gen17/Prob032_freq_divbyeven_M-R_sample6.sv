module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 6;  // Must be even number
localparam DIV_HALF = NUM_DIV / 2;

wire [3:0] cnt_next;
reg [3:0] cnt;
reg toggle;

// Continuous counter logic
assign cnt_next = (!rst_n) ? 4'b0 : 
                 (cnt == DIV_HALF - 1) ? 4'b0 : cnt + 1;

// Continuous toggle logic
assign toggle_next = (!rst_n) ? 1'b0 : 
                    (cnt == DIV_HALF - 1) ? ~toggle : toggle;

// Register updates
always @(posedge clk) begin
    cnt <= cnt_next;
    toggle <= toggle_next;
end

// Output assignment
assign clk_div = toggle;

endmodule