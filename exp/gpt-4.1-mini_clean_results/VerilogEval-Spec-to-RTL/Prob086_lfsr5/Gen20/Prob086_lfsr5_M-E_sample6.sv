module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        // Calculate feedback bit based on taps at positions 5 (q[4]) and 3 (q[2]) with q[0]
        wire feedback = q[0] ^ q[2] ^ q[4];
        q <= {feedback, q[4:1]}; // Shift right inserting feedback at MSB
    end
end

endmodule