module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

parameter ACTIVE_HIGH_RESET = 1; // Set to 0 for active-low reset

wire gated_clk = (q == d) ? 1'b0 : clk; // Clock gating when data is stable

always @(posedge gated_clk or posedge ar) begin
    if (ACTIVE_HIGH_RESET) begin
        if (ar) q <= 1'b0;
        else    q <= d;
    end else begin
        if (~ar) q <= 1'b0;
        else     q <= d;
    end
end

endmodule