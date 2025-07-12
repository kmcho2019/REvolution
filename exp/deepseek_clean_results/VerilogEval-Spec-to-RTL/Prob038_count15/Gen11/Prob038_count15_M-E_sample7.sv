module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

// Feedback terms for binary counting sequence
wire feedback = &count[2:0];  // AND of all lower bits
wire feedback2 = &count[1:0];
wire feedback3 = count[0];

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000;
    end else begin
        // LFSR-style update with custom feedback
        count[3] <= count[3] ^ (feedback & count[2] & count[1] & count[0]);
        count[2] <= count[2] ^ (feedback2 & count[1] & count[0]);
        count[1] <= count[1] ^ (feedback3 & count[0]);
        count[0] <= count[0] ^ 1'b1;  // LSB always toggles
    end
end

assign q = count;

endmodule