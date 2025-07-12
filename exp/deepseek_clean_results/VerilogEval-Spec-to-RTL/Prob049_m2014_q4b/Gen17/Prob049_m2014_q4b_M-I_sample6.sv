module TopModule (
    input clk,
    input ar,        // Active-high async reset
    input d,
    output reg q
);

// Internal clock gating signal
wire gated_clk;
reg d_prev;

// Clock gating when 'd' is stable
assign gated_clk = (d != d_prev) ? clk : 1'b0;

always @(posedge gated_clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;
        d_prev <= 1'b0;  // Reset previous value
    end
    else begin
        q <= d;
        d_prev <= d;     // Store current value
    end
end

endmodule