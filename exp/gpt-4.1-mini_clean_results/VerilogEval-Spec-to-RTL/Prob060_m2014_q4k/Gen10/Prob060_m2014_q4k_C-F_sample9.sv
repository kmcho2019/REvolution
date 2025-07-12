module DFF_sync_resetn #(
    parameter INIT = 1'b0
) (
    input  clk,
    input  resetn,
    input  d,
    output reg q
);
    // Synchronous active-low reset DFF with parameterized initial value for flexibility
    always @(posedge clk) begin
        if (~resetn)
            q <= INIT;
        else
            q <= d;
    end
endmodule

module ShiftReg #(
    parameter WIDTH = 4
) (
    input  clk,
    input  resetn,
    input  in,
    output out
);
    wire [WIDTH-1:0] q;
    wire [WIDTH-1:0] d;
    genvar i;

    // Input to first stage
    assign d[0] = in;
    // Each next stage input is output of previous stage
    assign d[WIDTH-1:1] = q[WIDTH-2:0];

    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : dff_chain
            DFF_sync_resetn #(.INIT(1'b0)) dff_inst (
                .clk(clk),
                .resetn(resetn),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

    assign out = q[WIDTH-1];
endmodule

module TopModule (
    input  clk,
    input  resetn,
    input  in,
    output out
);
    // Instantiate 4-bit shift register with synchronous active-low reset
    ShiftReg #(.WIDTH(4)) shift_reg_inst (
        .clk(clk),
        .resetn(resetn),
        .in(in),
        .out(out)
    );
endmodule