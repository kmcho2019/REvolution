module DFF_AR (
    input       clk,
    input       areset,   // Active-high asynchronous reset
    input       d,
    output reg  q
);
    // Asynchronous reset flip-flop with positive edge clock triggering
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 1'b0;    // Reset output to zero asynchronously
        else
            q <= d;       // On clock edge, capture input data
    end
endmodule

module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output [7:0] q
);
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_array
            DFF_AR dff_inst (
                .clk(clk),
                .areset(areset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule