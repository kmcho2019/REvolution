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
        case (L)
            1'b1: mux_out = r_in;
            1'b0: mux_out = q_in;
            default: mux_out = 1'bx; // Handle undefined states
        endcase
    end

    // Sequential logic for flip-flop
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule