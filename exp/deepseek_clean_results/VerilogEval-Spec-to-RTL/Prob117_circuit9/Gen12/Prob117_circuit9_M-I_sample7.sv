module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire reset_cond = &q;  // q == 3'b110 (6)
wire a_changed = (a != a_prev);
reg a_prev;

always @(posedge clk) begin
    a_prev <= a;
    
    if (a) begin
        if (a_changed) q <= 3'd4;  // Only update when a changes
    end
    else begin
        if (reset_cond) q <= 3'd0;
        else q <= q + 1'b1;
    end
end

endmodule