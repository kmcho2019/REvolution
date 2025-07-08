module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // reset to 1
        end else begin
            // taps at bits 5 and 3 -> q[4] and q[2]
            wire feedback = q[0];
            q[0] <= q[1];
            q[1] <= q[2];
            q[2] <= q[3] ^ feedback; 
            q[3] <= q[4];
            q[4] <= feedback;
        end
    end

endmodule