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
        for (i = 0; i < 16; i = i + 1) begin : dff_array
            // Efficient enable selection using bit position (i[3] for upper byte)
            DFF #(.WIDTH(1)) dff_inst (
                .clk(clk),
                .resetn(resetn),
                .enable(byteena[i[3]]),  // i[3] selects between byteena[1] and byteena[0]
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

endmodule