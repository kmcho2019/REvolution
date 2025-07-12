module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Precompute all shift variants
    wire [63:0] shift_left_1  = {q[62:0], 1'b0};
    wire [63:0] shift_left_8  = {q[55:0], 8'b0};
    wire [63:0] shift_right_1 = {msb, q[63:1]};
    wire [63:0] shift_right_8 = {{8{msb}}, q[63:8]};

    // 4:1 mux selecting shift based on amount
    // amount encoding:
    // 00 - shift left 1
    // 01 - shift left 8
    // 10 - shift right 1 (arithmetic)
    // 11 - shift right 8 (arithmetic)
    wire [63:0] shifted;

    assign shifted = (amount == 2'b00) ? shift_left_1  :
                     (amount == 2'b01) ? shift_left_8  :
                     (amount == 2'b10) ? shift_right_1 :
                                         shift_right_8;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
    end

endmodule