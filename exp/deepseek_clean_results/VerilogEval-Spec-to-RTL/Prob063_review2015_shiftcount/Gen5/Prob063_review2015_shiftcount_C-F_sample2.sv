module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] next_q;
wire enable;

assign enable = shift_ena | count_ena;

// Combinational next state logic with operand isolation
assign next_q = shift_ena ? {q[2:0], data} :  // Left shift (MSB first)
                count_ena ? q - 1'b1 :        // Decrement with isolation
                q;                            // Hold value

// Sequential state update with conditional clock gating
always @(posedge clk) begin
    if (enable) begin
        q <= next_q;
    end
end

endmodule