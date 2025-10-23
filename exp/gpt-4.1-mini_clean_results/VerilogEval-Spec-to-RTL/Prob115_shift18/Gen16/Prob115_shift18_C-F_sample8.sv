module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Shift left variants (logical shifts with zero fill)
    wire [63:0] shift_left_1  = {q[62:0], 1'b0};
    wire [63:0] shift_left_8  = {q[55:0], 8'b0};

    // Arithmetic right shifts with sign extension
    wire [63:0] shift_right_1 = {msb, q[63:1]};
    wire [63:0] shift_right_8 = {{8{msb}}, q[63:8]};

    // Select shift amount based on amount[0]
    wire [63:0] shift_left_sel  = (amount[0] == 1'b0) ? shift_left_1 : shift_left_8;
    wire [63:0] shift_right_sel = (amount[0] == 1'b0) ? shift_right_1 : shift_right_8;

    // Select shift direction based on amount[1]
    wire [63:0] shift_val = (amount[1] == 1'b0) ? shift_left_sel : shift_right_sel;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shift_val;
        end
    end

endmodule