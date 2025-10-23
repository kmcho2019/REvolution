module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    // Initialize flip-flop to avoid X propagation
    initial begin
        Q = 1'b0;
    end

    // Simple 2:1 mux for load operation
    wire mux_out = L ? r_in : q_in;

    // D flip-flop for storage
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule