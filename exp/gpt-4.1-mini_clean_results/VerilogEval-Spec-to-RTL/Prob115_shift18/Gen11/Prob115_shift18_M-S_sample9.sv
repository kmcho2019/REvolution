module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Left shifts by wiring
    wire [63:0] left_1  = {q[62:0], 1'b0};
    wire [63:0] left_8  = {q[55:0], 8'd0};

    // Arithmetic right shifts by wiring
    wire [63:0] right_1 = {msb, q[63:1]};
    wire [63:0] right_8 = {{8{msb}}, q[63:8]};

    // Select shift by amount[0]
    wire [63:0] left_shift  = amount[0] ? left_8  : left_1;
    wire [63:0] right_shift = amount[0] ? right_8 : right_1;

    // Select direction by amount[1]
    wire [63:0] shift_val = amount[1] ? right_shift : left_shift;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shift_val;
    end

endmodule