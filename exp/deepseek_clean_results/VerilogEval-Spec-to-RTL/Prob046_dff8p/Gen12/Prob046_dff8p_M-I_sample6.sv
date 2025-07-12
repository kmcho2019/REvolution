module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

localparam RESET_VAL = 8'h34;
reg [7:0] d_prev;
reg clk_en;

// Clock gating control
always @(negedge clk) begin
    d_prev <= d;
    clk_en <= (d != d_prev) || reset;
end

// Main flip-flop logic with gated clock
always @(negedge clk or posedge reset) begin
    if (reset) begin
        q <= RESET_VAL;
    end else if (clk_en) begin
        q <= d;
    end
end

endmodule