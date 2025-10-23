module DFF (
    input clk,
    input reset,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);
    wire [7:0] q_internal;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_array
            DFF dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q_internal[i])
            );
        end
    endgenerate

    assign q = q_internal;
endmodule