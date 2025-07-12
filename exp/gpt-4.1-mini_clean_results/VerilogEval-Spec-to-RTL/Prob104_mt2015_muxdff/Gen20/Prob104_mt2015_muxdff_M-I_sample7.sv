module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q = 0  // initialize to 0 to avoid unknown startup states
);

    wire D; // output of the 2:1 mux

    assign D = L ? r_in : q_in;

    always @(posedge clk) begin
        Q <= D;
    end

endmodule