module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else begin
        // Calculate feedback based on the current LSB
        wire feedback = q[0];
        // Next state vector combines shifted bits and XOR taps at q[4] and q[2]
        q <= {feedback, q[4], q[3] ^ feedback, q[2], q[1]};
    end
end

endmodule