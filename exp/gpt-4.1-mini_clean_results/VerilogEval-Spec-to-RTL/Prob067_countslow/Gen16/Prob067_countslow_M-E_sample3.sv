module TopModule (
    input wire clk,
    input wire reset,
    input wire slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else if (slowena) begin
        if (q == 4'd9)
            q <= 4'd0;
        else
            q <= q + 4'd1;
    end
    // else hold q
end

endmodule