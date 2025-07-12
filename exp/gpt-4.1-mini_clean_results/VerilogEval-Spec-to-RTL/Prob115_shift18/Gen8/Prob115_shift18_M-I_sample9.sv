module TopModule (
    input             clk,
    input             load,
    input             ena,
    input      [1:0]  amount,
    input      [63:0] data,
    output reg [63:0] q
);

    wire shift_by_8 = amount[0];
    wire dir_right = amount[1];  // 0: left shift, 1: arithmetic right shift

    // First stage: shift by 8 bits or 1 bit, direction agnostic
    wire [63:0] shift8_left  = {q[55:0], 8'b0};
    wire [63:0] shift1_left  = {q[62:0], 1'b0};
    wire [63:0] shift8_right = { {8{q[63]}}, q[63:8] };
    wire [63:0] shift1_right = { {1{q[63]}}, q[63:1] };

    wire [63:0] shifted_amount = shift_by_8 ? 
                                (dir_right ? shift8_right : shift8_left) :
                                (dir_right ? shift1_right : shift1_left);

    wire [63:0] next_q = load ? data : (ena ? shifted_amount : q);

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule