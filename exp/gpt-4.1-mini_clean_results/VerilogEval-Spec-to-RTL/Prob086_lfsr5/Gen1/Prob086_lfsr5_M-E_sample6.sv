module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    reg [4:0] next_q;
    wire feedback;

    assign feedback = q[0];

    always @(*) begin
        // Compute next state of the LFSR
        // Save current q[2] and q[3] for clarity
        // next_q[0] = q[1]
        // next_q[1] = q[2]
        // next_q[2] = q[3] ^ feedback
        // next_q[3] = q[4]
        // next_q[4] = feedback ^ q[2]

        next_q[0] = q[1];
        next_q[1] = q[2];
        next_q[2] = q[3] ^ feedback;
        next_q[3] = q[4];
        next_q[4] = feedback ^ q[2];
    end

    always @(posedge clk) begin
        if (reset)
            q <= 5'b00001;
        else
            q <= next_q;
    end

endmodule