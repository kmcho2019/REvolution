module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

wire clk_en;
reg [WIDTH-1:0] d_prev;

// Clock gating control: only enable clock when input changes or reset is active
assign clk_en = (d != d_prev) || reset;

always @(posedge clk) begin
    d_prev <= d;  // Store previous input for comparison
    
    if (clk_en) begin
        if (reset) begin
            q <= {WIDTH{1'b0}};  // Synchronous reset to 0
        end else begin
            q <= d;              // Capture input on rising edge
        end
    end
end

endmodule