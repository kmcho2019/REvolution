module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 4;  // reset to 4 when a=1
    end else begin
        // increment with wrap-around from 6 to 0
        if (q == 6)
            q <= 0;
        else
            q <= q + 1;
    end
end

endmodule