module DFF #(
    parameter WIDTH = 1
) (
    input clk,
    input resetn,
    input enable,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk) begin
        if (!resetn) begin
            q <= {WIDTH{1'b0}};
        end else if (enable) begin
            q <= d;
        end
    end
endmodule

module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : bit_gen
            // Determine which byte enable to use based on bit position
            wire bit_enable = (i >= 8) ? byteena[1] : byteena[0];
            
            DFF #(.WIDTH(1)) dff_inst (
                .clk(clk),
                .resetn(resetn),
                .enable(bit_enable),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

endmodule