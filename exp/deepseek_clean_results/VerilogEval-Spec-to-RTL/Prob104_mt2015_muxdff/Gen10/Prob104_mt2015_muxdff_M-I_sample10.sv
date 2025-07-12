module TopModule (
    input clk,
    input L,
    input q_in,     // Current bit value
    input r_in,     // Load value
    input q0,       // Value of q[0] (for position 1 and 2)
    input q1,       // Value of q[1] (for position 0)
    input [1:0] pos, // Position indicator (0, 1, or 2)
    output reg Q
);

    // Internal mux output
    reg mux_out;

    // Combinational logic for mux
    always @(*) begin
        if (L) begin
            mux_out = r_in;
        end else begin
            case (pos)
                2'd0: mux_out = q1 ^ Q;  // q[1] ^ q[2] (current Q is q[2])
                2'd1: mux_out = q0;      // Original q[0]
                2'd2: mux_out = Q;       // Original q[2]
                default: mux_out = q_in;
            endcase
        end
    end

    // Sequential logic for flip-flop
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule