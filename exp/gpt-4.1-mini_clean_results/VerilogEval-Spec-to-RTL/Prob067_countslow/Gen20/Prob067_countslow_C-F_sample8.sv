module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

wire count_enable = slowena;

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else if (count_enable) begin
        if (q == 4'd9)
            q <= 4'd0;
        else
            q <= q + 4'd1;
    end
    // else hold current q
end

endmodule