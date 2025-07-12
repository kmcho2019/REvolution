module TopModule #(
    parameter IDX = 0 // Index 0,1,2 indicating which bit this instance represents
)(
    input  clk,
    input  L,
    input  r_in,
    input  q_in0,
    input  q_in1,
    input  q_in2,
    output reg Q
);

    // Compute next Q based on IDX and current q_in bits
    wire next_Q;
    generate
        if (IDX == 2) begin
            // Q[2] next = q[1] ^ q[2]
            assign next_Q = q_in1 ^ q_in2;
        end else if (IDX == 1) begin
            // Q[1] next = q[0]
            assign next_Q = q_in0;
        end else begin
            // IDX == 0: Q[0] next = q[2]
            assign next_Q = q_in2;
        end
    endgenerate

    always @(posedge clk) begin
        if (L)
            Q <= r_in;
        else
            Q <= next_Q;
    end

endmodule