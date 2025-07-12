module TopModule (
    input          clk,
    input          shift_ena,
    input          count_ena,
    input          data,
    output reg [3:0] q
);

// Control encoding: shift_ena has higher priority
wire [1:0] ctrl = {shift_ena, count_ena};

// Ripple borrow decrement logic for q - 1
wire borrow0 = 1'b1; // borrow in for decrement by 1
wire b1 = (~q[0]) & borrow0;
wire b2 = (~q[1]) & b1;
wire b3 = (~q[2]) & b2;

wire [3:0] dec_q;
assign dec_q[0] = q[0] ^ borrow0;
assign dec_q[1] = q[1] ^ b1;
assign dec_q[2] = q[2] ^ b2;
assign dec_q[3] = q[3] ^ b3;

reg [3:0] next_q;

always @* begin
    case (ctrl)
        2'b10: next_q = {q[2:0], data}; // Shift left by 1, data into LSB, MSB-first shift
        2'b01: next_q = dec_q;          // Decrement by 1 using ripple borrow logic
        default: next_q = q;            // Hold current value
    endcase
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule