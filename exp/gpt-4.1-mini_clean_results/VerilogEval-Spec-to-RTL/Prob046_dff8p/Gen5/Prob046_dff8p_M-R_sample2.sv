module DFF (
    input clk,
    input reset,
    input d,
    input reset_val,
    output reg q
);
    // Synchronous reset to reset_val on negedge clk
    always @(negedge clk) begin
        if (reset)
            q <= reset_val;
        else
            q <= d;
    end
endmodule

module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);

    wire [7:0] reset_val = 8'h34;
    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1) begin : dffs
            DFF dff_i (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .reset_val(reset_val[i]),
                .q(q[i])
            );
        end
    endgenerate

endmodule