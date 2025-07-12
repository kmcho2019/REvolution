module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Left shifts
    wire [63:0] shift_left_1 = q << 1;
    wire [63:0] shift_left_8 = q << 8;

    // Arithmetic right shifts with sign extension
    wire [63:0] shift_right_1 = {msb, q[63:1]};
    wire [63:0] shift_right_8 = {{8{msb}}, q[63:8]};

    // Select shift amount mux
    wire [63:0] left_shift_sel  = (amount[0] == 1'b0) ? shift_left_1 : shift_left_8;
    wire [63:0] right_shift_sel = (amount[0] == 1'b0) ? shift_right_1 : shift_right_8;

    // Final shifted output selection based on direction bit
    wire [63:0] shifted = (amount[1] == 1'b0) ? left_shift_sel : right_shift_sel;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
    end

endmodule