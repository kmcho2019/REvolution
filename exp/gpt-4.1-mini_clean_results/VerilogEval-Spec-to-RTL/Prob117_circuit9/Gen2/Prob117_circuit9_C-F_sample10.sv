module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        if (q != 3'd4)
            q <= 3'd4;  // assign only if q differs to reduce toggling
    end else begin
        if (q == 3'd6) begin
            if (q != 3'd0)
                q <= 3'd0;  // wrap only if changing value
        end else begin
            if (q != q + 3'd1)
                q <= q + 3'd1;  // increment only if value changes (always true, kept for symmetry)
        end
    end
end

endmodule