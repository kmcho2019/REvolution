module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

always @(posedge clk) begin
    reg mux_out;
    // Blocking assignment to capture mux output combinationally
    mux_out = L ? r_in : q_in;
    // Load flip-flop with mux output
    Q <= mux_out;
end

endmodule