module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    // Multiplexer logic combined into an assign statement
    wire d = L ? r_in : q_in;

    // D flip-flop with synchronous load via d
    always @(posedge clk) begin
        Q <= d;
    end

endmodule