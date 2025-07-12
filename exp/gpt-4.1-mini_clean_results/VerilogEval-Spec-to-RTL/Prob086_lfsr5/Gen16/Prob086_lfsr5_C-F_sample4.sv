module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    wire feedback;
    wire [4:0] next_q;

    assign feedback = q[0]; // feedback from LSB

    // Combinational next state logic according to Galois LFSR with taps at bits 5 (q[4]) and 3 (q[2])
    assign next_q[0] = q[1];
    assign next_q[1] = q[2];
    assign next_q[2] = q[3] ^ feedback;
    assign next_q[3] = q[4];
    assign next_q[4] = feedback;

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // synchronous reset to non-zero seed
        end else begin
            q <= next_q;
        end
    end

endmodule