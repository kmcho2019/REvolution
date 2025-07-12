module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    wire d;  // mux output

    // combinational 2:1 mux
    assign d = L ? r_in : q_in;

    // D flip-flop with synchronous load enable functionality
    always @(posedge clk) begin
        Q <= d;
    end

endmodule