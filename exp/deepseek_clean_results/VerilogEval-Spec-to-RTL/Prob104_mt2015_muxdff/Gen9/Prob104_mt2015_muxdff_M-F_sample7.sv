module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    // Internal mux output
    reg mux_out;

    // Combinational logic for mux
    always @(*) begin
        if (L)
            mux_out = r_in;
        else
            mux_out = q_in;
    end

    // Sequential logic for flip-flop
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule