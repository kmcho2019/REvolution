module DFF_NegSyncReset (
    input clk,
    input reset,
    input d,
    output reg q,
    input reset_val
);
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
    wire [7:0] reset_const = 8'h34;
    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_array
            DFF_NegSyncReset dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i]),
                .reset_val(reset_const[i])
            );
        end
    endgenerate
endmodule