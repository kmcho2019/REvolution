module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;
wire clk_en = ~a;  // Clock enable - only when a=0 (need to count)

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;  // synchronous reset to 4 when a=1
    end else if (clk_en) begin
        q <= next_q;  // update only when counting
    end
end

// Pipelined increment logic
always @(*) begin
    if (q == 3'd6) begin
        next_q = 3'd0;  // wrap-around
    end else begin
        next_q = q + 3'd1;  // increment
    end
end

endmodule