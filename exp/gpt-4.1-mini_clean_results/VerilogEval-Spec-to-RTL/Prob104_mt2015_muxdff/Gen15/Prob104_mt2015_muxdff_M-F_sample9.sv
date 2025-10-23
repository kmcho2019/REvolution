module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    // Initialize Q to 0 to avoid unknown startup state in simulation
    initial Q = 0;

    wire d = L ? r_in : q_in;

    always @(posedge clk) begin
        Q <= d;
    end

endmodule