module TopModule (
    input          clk,
    input          shift_ena,
    input          count_ena,
    input          data,
    output reg [3:0] q
);

// Control encoding:
// 2'b10 -> shift_ena active
// 2'b01 -> count_ena active
// 2'b00 -> hold
wire [1:0] ctrl = {shift_ena, count_ena};

reg [3:0] next_q;

// Ripple borrow decrement logic for count_ena case
wire [3:0] dec_q;
wire borrow0 = 1'b1; // since decrement by 1, initial borrow-in is 1
wire b1 = (~q[0]) & borrow0;
wire b2 = (~q[1]) & b1;
wire b3 = (~q[2]) & b2;
assign dec_q[0] = q[0] ^ borrow0;
assign dec_q[1] = q[1] ^ b1;
assign dec_q[2] = q[2] ^ b2;
assign dec_q[3] = q[3] ^ b3;

always @* begin
    case (ctrl)
        2'b10: next_q = {q[2:0], data}; // shift left in MSB with data
        2'b01: next_q = dec_q;           // decrement using ripple borrow logic
        default: next_q = q;             // hold current value
    endcase
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule