module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

wire gated_clk;
reg clear_n;

// Clock gating logic
assign gated_clk = clk & ~r;

// Asynchronous clear control (synchronously generated)
always @(posedge clk) begin
    clear_n <= ~r;
end

// Main flip-flop with gated clock and async clear
always @(posedge gated_clk or negedge clear_n) begin
    if (!clear_n) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule