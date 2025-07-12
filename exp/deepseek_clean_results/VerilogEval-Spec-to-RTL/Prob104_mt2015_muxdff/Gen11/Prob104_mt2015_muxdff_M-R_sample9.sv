module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    // Continuous assignment for 2:1 mux
    wire mux_out;
    assign mux_out = L ? r_in : q_in;

    // D flip-flop with initialization
    initial Q = 1'b0;
    
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule