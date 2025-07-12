module DFF_sync_resetn (
    input clk,
    input resetn,
    input d,
    output reg q
);
    // Synchronous active-low reset DFF
    always @(posedge clk) begin
        if (~resetn)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module ShiftReg4 (
    input clk,
    input resetn,
    input in,
    output out
);
    wire [3:0] q;
    wire [3:0] d;

    assign d[0] = in;
    assign d[3:1] = q[2:0];

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : dffs
            DFF_sync_resetn dff_inst (
                .clk(clk),
                .resetn(resetn),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

    assign out = q[3];
endmodule

module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);
    ShiftReg4 shift_reg_inst (
        .clk(clk),
        .resetn(resetn),
        .in(in),
        .out(out)
    );
endmodule