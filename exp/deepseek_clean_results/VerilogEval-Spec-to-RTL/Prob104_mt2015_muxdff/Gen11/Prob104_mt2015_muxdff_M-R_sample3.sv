module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    // 2:1 mux using continuous assignment
    assign mux_out = L ? r_in : q_in;

    // D flip-flop for storage
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule