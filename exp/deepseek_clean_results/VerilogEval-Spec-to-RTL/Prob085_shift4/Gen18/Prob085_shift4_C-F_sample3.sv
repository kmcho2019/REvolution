module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end
    else if (load) begin
        q <= data;
    end
    else if (ena) begin
        // Right shift with zero fill
        q <= {1'b0, q[3:1]};
    end
    // Implicit else: retain value (no latch inferred)
end

// Note: For actual clock gating implementation, you would need:
// (* gated_clock = "ena" *) reg [3:0] q;
// But this is tool-dependent and may require specific synthesis directives

endmodule