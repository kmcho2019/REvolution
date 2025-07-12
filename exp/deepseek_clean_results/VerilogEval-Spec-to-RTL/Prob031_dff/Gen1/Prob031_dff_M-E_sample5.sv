module TopModule (
    input clk,
    input d,
    output reg q
);

// Internal synchronous reset signal
wire reset = 1'b0;  // Normally tied low, but provides hook for future expansion

always @(posedge clk) begin
    if (reset) begin
        q <= 1'b0;
    end
    else begin
        q <= d;
    end
end

endmodule