// Define a module for a single D flip-flop with active high synchronous reset
module DFF(
    input clk,
    input reset,
    input d,
    output reg q
);

always @(negedge clk) begin
    if(reset) begin
        q <= 1'b0; // Reset to 0, will be ORed with the desired reset value later
    end else begin
        q <= d;
    end
end

endmodule

// Define the TopModule with 8 D flip-flops
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

wire [7:0] reset_value = 8'd52; // 0x34 in decimal is 52

// Instantiate 8 D flip-flops
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        DFF dff(
            .clk(clk),
            .reset(reset || (q[i] != reset_value[i])),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule