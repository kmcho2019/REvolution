module TopModule (
    input          clk,
    input          shift_ena,
    input          count_ena,
    input          data,
    output reg [3:0] q
);

// Combinational next state signals
wire [3:0] dec_q = q - 4'b0001;           // arithmetic decrement
wire [3:0] shift_q = {q[2:0], data};      // shift left, MSB first

wire [3:0] next_q = shift_ena ? shift_q :
                   count_ena ? dec_q :
                   q;

always @(posedge clk) begin
    q <= next_q;
end

endmodule