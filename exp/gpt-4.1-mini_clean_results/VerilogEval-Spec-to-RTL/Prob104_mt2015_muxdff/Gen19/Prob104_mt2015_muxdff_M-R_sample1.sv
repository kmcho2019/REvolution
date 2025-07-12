module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    wire D; // output of the 2:1 mux

    assign D = L ? r_in : q_in;

    always @(posedge clk) begin
        Q <= D;
    end

endmodule