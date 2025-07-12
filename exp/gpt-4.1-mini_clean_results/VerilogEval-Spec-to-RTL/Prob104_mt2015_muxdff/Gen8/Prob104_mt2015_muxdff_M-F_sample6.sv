module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    wire d;  // mux output

    assign d = L ? r_in : q_in;

    initial begin
        Q = 0;
    end

    always @(posedge clk) begin
        Q <= d;
    end

endmodule