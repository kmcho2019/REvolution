module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    wire feedback;
    reg  [4:0] next_q;

    assign feedback = q[0];

    // Combinational logic to compute next state
    always @* begin
        // Following Galois LFSR logic with taps at bit positions 5 and 3 (q[4] and q[2])
        next_q[4] = feedback;
        next_q[3] = q[4];
        next_q[2] = q[3] ^ feedback;
        next_q[1] = q[2];
        next_q[0] = q[1];
    end

    // Sequential register update
    always @(posedge clk) begin
        if (reset)
            q <= 5'b00001;  // synchronous reset to 1
        else
            q <= next_q;
    end

endmodule