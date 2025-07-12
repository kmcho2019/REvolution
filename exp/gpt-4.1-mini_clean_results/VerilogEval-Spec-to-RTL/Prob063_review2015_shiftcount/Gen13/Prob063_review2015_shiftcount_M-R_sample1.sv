module TopModule (
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

wire [3:0] shift_val = {q[2:0], data};  // Shift left, MSB in
wire [3:0] dec_val   = q - 4'd1;        // Decrement by 1

// Priority mux for next state:
// If shift_ena is asserted, shift takes priority
wire [3:0] next_q = shift_ena ? shift_val :
                    count_ena ? dec_val :
                    q;           // Hold current value if no enable

always @(posedge clk) begin
    q <= next_q;
end

endmodule