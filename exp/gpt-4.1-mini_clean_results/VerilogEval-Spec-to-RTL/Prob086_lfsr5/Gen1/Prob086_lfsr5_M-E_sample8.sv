module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // Save the current LSB as feedback bit
            wire feedback = q[0];

            // Prepare next state bits one by one
            reg [4:0] next_q;

            // Tap positions (5 and 3) correspond to bits q[4] and q[2]
            // These get XORed with feedback
            next_q[4] = q[4] ^ feedback;
            next_q[3] = q[4];
            next_q[2] = q[2] ^ feedback;
            next_q[1] = q[2];
            next_q[0] = q[1];

            q <= next_q;
        end
    end

endmodule