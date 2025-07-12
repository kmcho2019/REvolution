module TopModule(
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

    // Calculate next state of the shift register
    assign next_Q = enable ? {Q[6:0], S} : Q;

    // Sequential logic to update Q on positive clock edge
    always @(posedge clk) begin
        Q <= next_Q;
    end

    // Multiplexer output by indexing the register with sel
    assign Z = Q[sel];

endmodule