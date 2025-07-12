module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

// Generate gated clock enable: active only when load or ena is high
wire clk_en = load | ena;
reg gated_clk;
reg gated_clk_d;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        gated_clk <= 1'b0;
        gated_clk_d <= 1'b0;
    end else begin
        gated_clk_d <= clk_en;
        gated_clk <= gated_clk_d & clk_en;
    end
end

// Instead of true gated clock, use enable signal to minimize clock toggling in downstream logic
// Synchronous logic with asynchronous reset and clock enable for reduced toggling

always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0;
    else if (clk_en) begin
        if (load)
            q <= data;
        else // ena only when load is 0
            q <= {1'b0, q[3:1]};
    end
end

endmodule