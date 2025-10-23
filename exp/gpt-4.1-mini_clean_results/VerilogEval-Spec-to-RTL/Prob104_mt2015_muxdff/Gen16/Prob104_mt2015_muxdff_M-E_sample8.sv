module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    wire d;

    // Multiplexer selects loaded input when L=1, otherwise shifts in q_in
    assign d = L ? r_in : q_in;

    always @(posedge clk) begin
        Q <= d;
    end

endmodule