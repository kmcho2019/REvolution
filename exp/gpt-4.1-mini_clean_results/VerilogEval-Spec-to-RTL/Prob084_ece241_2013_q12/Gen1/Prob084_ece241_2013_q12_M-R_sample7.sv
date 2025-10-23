module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    reg [7:0] Q;
    wire [7:0] next_Q;

    // Compute next state for each flip-flop individually
    assign next_Q[0] = S;
    assign next_Q[1] = Q[0];
    assign next_Q[2] = Q[1];
    assign next_Q[3] = Q[2];
    assign next_Q[4] = Q[3];
    assign next_Q[5] = Q[4];
    assign next_Q[6] = Q[5];
    assign next_Q[7] = Q[6];

    // Shift register update on clock edge with enable gating
    always @(posedge clk) begin
        if (enable) begin
            Q <= next_Q;
        end
    end

    // Output multiplexer indexed by inputs A, B, C
    wire [2:0] sel = {A, B, C};
    assign Z = Q[sel];

endmodule