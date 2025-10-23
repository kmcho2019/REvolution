module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    wire next_Q;

    // Combinational logic to determine next state of Q
    assign next_Q = L ? R : (E ? w : Q);

    // Sequential update of Q on rising clock edge
    always @(posedge clk) begin
        Q <= next_Q;
    end

endmodule