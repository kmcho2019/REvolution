module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else begin
        // Compute next count value explicitly for clarity
        reg [3:0] next_q;
        if (q == 4'd9)
            next_q = 4'd0;
        else
            next_q = q + 4'd1;
        q <= next_q;
    end
end

endmodule