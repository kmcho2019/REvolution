module TopModule #(
    parameter POS = 0  // 0=LSB, 1=middle, 2=MSB
)(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    // Feedback selection logic
    wire feedback = (POS == 2) ? (q_in ^ Q) :  // MSB: XOR feedback
                   (POS == 1) ? q_in :        // Middle: pass q[0]
                   Q;                         // LSB: pass q[2] (circular)

    // Mux for load/shift selection
    wire mux_out = L ? r_in : feedback;

    // D flip-flop for storage
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule