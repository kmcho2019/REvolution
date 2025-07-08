module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);
    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // Compute next state
            // taps at bit 5 and 3 => q[4] and q[2]
            wire feedback = q[0];
            q[0] <= q[1];
            q[1] <= q[2];
            q[2] <= q[3] ^ feedback;
            q[3] <= q[4];
            q[4] <= feedback ^ q[2]; // Here q[2] is old q[2], must store old q[2] before update
        end
    end
endmodule