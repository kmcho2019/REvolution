module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire d;

    // 2:1 MUX: if L=1 load r_in else keep q_in
    assign d = L ? r_in : q_in;

    // Flip-flop capturing selected input at rising edge of clk
    always @(posedge clk) begin
        Q <= d;
    end

endmodule