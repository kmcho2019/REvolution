module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    wire [7:0] Q;

    // Generate 8 D flip-flops for the shift register
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_stage
            wire d_in;
            if (i == 0) begin
                assign d_in = S;
            end else begin
                assign d_in = Q[i-1];
            end

            DFF dff_inst (
                .clk(clk),
                .enable(enable),
                .d(d_in),
                .q(Q[i])
            );
        end
    endgenerate

    // 8-to-1 multiplexer to select one bit from Q based on {A,B,C}
    Mux8to1 mux_inst (
        .sel({A, B, C}),
        .in(Q),
        .out(Z)
    );

endmodule


// D Flip-Flop with synchronous enable and positive-edge clock
module DFF (
    input clk,
    input enable,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (enable)
            q <= d;
    end
endmodule


// 8-to-1 Multiplexer module
module Mux8to1 (
    input [2:0] sel,
    input [7:0] in,
    output reg out
);
    always @(*) begin
        case (sel)
            3'd0: out = in[0];
            3'd1: out = in[1];
            3'd2: out = in[2];
            3'd3: out = in[3];
            3'd4: out = in[4];
            3'd5: out = in[5];
            3'd6: out = in[6];
            3'd7: out = in[7];
            default: out = 1'b0; // fallback, not expected
        endcase
    end
endmodule