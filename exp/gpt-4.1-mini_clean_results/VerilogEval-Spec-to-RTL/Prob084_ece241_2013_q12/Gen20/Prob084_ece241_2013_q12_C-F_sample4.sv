module DFF (
    input  clk,
    input  enable,
    input  d,
    output reg q
);
    always @(posedge clk) begin
        if (enable)
            q <= d;
    end
endmodule

module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output reg Z
);

    wire [7:0] Q;

    // Instantiate 8 D flip-flops forming the shift register
    // Shift direction: Q[0] is MSB, shifted right, S shifted into Q[0]
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : SHIFT_REG
            if (i == 0) begin
                DFF dff_inst (
                    .clk(clk),
                    .enable(enable),
                    .d(S),
                    .q(Q[0])
                );
            end else begin
                DFF dff_inst (
                    .clk(clk),
                    .enable(enable),
                    .d(Q[i-1]),
                    .q(Q[i])
                );
            end
        end
    endgenerate

    // 8-to-1 multiplexer selecting Q[{A,B,C}] explicitly using case statement
    always @(*) begin
        case ({A, B, C})
            3'd0: Z = Q[0];
            3'd1: Z = Q[1];
            3'd2: Z = Q[2];
            3'd3: Z = Q[3];
            3'd4: Z = Q[4];
            3'd5: Z = Q[5];
            3'd6: Z = Q[6];
            3'd7: Z = Q[7];
            default: Z = 1'b0; // Default safe assignment
        endcase
    end

endmodule