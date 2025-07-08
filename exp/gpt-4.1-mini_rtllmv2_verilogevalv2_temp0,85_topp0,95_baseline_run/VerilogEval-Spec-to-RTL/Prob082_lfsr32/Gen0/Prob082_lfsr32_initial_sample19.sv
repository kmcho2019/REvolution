module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions (1-based): 32, 22, 2, 1
    // Zero-based bits: 31, 21, 1, 0

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            wire feedback = q[0];
            reg [31:0] next_q;
            // Shift right by 1 bit with feedback XOR at tap positions
            // next_q[31] = q[0] XOR feedback because bit 31 is a tap position
            // next_q[i] = q[i+1] XOR feedback if i is a tap position else q[i+1]
            next_q[31] = q[0] ^ feedback;         // bit 32 tap
            next_q[21] = q[22] ^ feedback;        // bit 22 tap
            next_q[1]  = q[2]  ^ feedback;        // bit 2 tap
            next_q[0]  = q[1]  ^ feedback;        // bit 1 tap

            // Other bits just shift right unchanged
            integer i;
            for (i = 0; i < 32; i = i + 1) begin
                if (i != 31 && i != 21 && i != 1 && i != 0) begin
                    next_q[i] = q[i+1];
                end
            end

            q <= next_q;
        end
    end

endmodule