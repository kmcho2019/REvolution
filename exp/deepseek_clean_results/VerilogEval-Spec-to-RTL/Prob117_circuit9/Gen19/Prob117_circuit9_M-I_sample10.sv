module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg wrap_around;
wire [2:0] next_q;

// Clock gating logic (power optimization)
wire gated_clk = clk & (~a | (q != 3'b100));

// Separate increment and wrap-around logic (timing optimization)
assign next_q = q + 1'b1;
assign wrap_around = (q == 3'b110);

always @(posedge gated_clk) begin
    if (a) begin
        q <= 3'b100;  // Force to 4 when a is high
    end else begin
        q <= wrap_around ? 3'b000 : next_q;
    end
end

// Synchronous reset initialization (area optimization)
initial begin
    q = 3'b100;
end

endmodule