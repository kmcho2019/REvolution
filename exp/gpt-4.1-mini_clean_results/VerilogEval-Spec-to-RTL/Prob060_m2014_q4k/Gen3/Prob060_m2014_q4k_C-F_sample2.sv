module DFF (
    input clk,
    input resetn,
    input d,
    output reg q
);
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
    genvar i;

    // Instantiate 4 chained DFFs
    generate
        for (i = 0; i < 4; i = i + 1) begin : dff_chain
            if (i == 0) begin
                DFF ff(.clk(clk), .resetn(resetn), .d(in), .q(q[i]));
            end else begin
                DFF ff(.clk(clk), .resetn(resetn), .d(q[i-1]), .q(q[i]));
            end
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