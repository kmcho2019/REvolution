module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [7:0] Q;
    wire [7:0] next_Q;
    wire [2:0] sel = {A, B, C};

    // Shift register implemented with continuous assignments
    assign next_Q[0] = enable ? S : Q[0];
    assign next_Q[1] = enable ? Q[0] : Q[1];
    assign next_Q[2] = enable ? Q[1] : Q[2];
    assign next_Q[3] = enable ? Q[2] : Q[3];
    assign next_Q[4] = enable ? Q[3] : Q[4];
    assign next_Q[5] = enable ? Q[4] : Q[5];
    assign next_Q[6] = enable ? Q[5] : Q[6];
    assign next_Q[7] = enable ? Q[6] : Q[7];

    // Clocked flip-flops
    always @(posedge clk) begin
        Q <= next_Q;
    end

    // Direct-index multiplexer
    assign Z = Q[sel];
endmodule