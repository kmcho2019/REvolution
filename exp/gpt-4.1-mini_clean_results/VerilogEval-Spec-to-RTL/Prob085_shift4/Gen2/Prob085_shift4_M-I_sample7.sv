module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

// Internal gated clock enable: active when load or ena is asserted
wire clk_en = load | ena;

// Use clock gating for power reduction; instantiate gated clock
// For demonstration, use the enable in always block to mimic gating
always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0;
    else if (clk_en) begin
        if (load)
            q <= data;
        else // ena must be high here
            q <= {1'b0, q[3:1]};
    end
    // else retain q (no change)
end

endmodule