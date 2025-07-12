// Single-bit D flip-flop with asynchronous active-high reset
module DFF_AR_bit (
    input  wire clk,
    input  wire areset,    // Asynchronous active-high reset
    input  wire d,
    output reg  q
);
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 1'b0;     // Asynchronously reset output to zero
        else
            q <= d;        // Latch data on rising clock edge
    end
endmodule

module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire [7:0] d,
    output wire [7:0] q
);
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_array
            DFF_AR_bit dff_inst (
                .clk(clk),
                .areset(areset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule