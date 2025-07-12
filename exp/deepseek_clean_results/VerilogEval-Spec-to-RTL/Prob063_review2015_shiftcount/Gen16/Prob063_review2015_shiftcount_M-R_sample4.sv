module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] next_q;

// Next state logic
assign next_q = shift_ena ? {q[2:0], data} :  // Shift operation
                count_ena ? q - 1 :           // Decrement operation
                q;                            // Hold current value

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule