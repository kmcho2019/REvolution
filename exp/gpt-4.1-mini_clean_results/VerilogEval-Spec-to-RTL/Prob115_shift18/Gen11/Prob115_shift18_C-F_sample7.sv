module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    reg [63:0] shifted_val;

    always @(*) begin
        // Extract the MSB for arithmetic right shift
        wire msb = q[63];

        // Shift left by 1 and 8
        wire [63:0] shift_left_1  = {q[62:0], 1'b0};
        wire [63:0] shift_left_8  = {q[55:0], 8'b0};

        // Arithmetic shift right by 1 and 8
        wire [63:0] shift_right_1 = {msb, q[63:1]};
        wire [63:0] shift_right_8 = {{8{msb}}, q[63:8]};

        // First mux: select shift amount within direction
        wire [63:0] shift_left_sel  = (amount[0] == 1'b0) ? shift_left_1 : shift_left_8;
        wire [63:0] shift_right_sel = (amount[0] == 1'b0) ? shift_right_1 : shift_right_8;

        // Second mux: select shift direction
        shifted_val = (amount[1] == 1'b0) ? shift_left_sel : shift_right_sel;
    end

    // Next state combinational logic
    wire [63:0] next_q = load ? data : (ena ? shifted_val : q);

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule