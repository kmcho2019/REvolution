module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    wire feedback = q[0];
    wire [4:0] next_state;

    // Compute next state based on current q and feedback
    assign next_state[0] = q[1];
    assign next_state[1] = q[2];
    assign next_state[2] = q[3] ^ feedback; // tap at bit 3
    assign next_state[3] = q[4];
    assign next_state[4] = feedback;        // tap at bit 5

    always @(posedge clk) begin
        if (reset) 
            q <= 5'b00001;
        else
            q <= next_state;
    end

endmodule