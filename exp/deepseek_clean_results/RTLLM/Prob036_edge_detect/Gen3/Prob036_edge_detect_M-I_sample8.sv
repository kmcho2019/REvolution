module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

reg a_prev;
wire rise_comb, down_comb;

// Sequential logic for storing previous value
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_prev <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end
    else begin
        a_prev <= a;
        rise <= rise_comb;
        down <= down_comb;
    end
end

// Combinational logic for edge detection
assign rise_comb = (~a_prev) & a;
assign down_comb = a_prev & (~a);

endmodule