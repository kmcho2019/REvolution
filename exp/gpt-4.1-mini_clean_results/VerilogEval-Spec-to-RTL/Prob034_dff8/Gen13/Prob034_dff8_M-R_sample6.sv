module DFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

    wire [7:0] q_wires;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dffs
            DFF dff_inst (
                .clk(clk),
                .d(d[i]),
                .q(q_wires[i])
            );
        end
    endgenerate

    assign q = q_wires;

endmodule