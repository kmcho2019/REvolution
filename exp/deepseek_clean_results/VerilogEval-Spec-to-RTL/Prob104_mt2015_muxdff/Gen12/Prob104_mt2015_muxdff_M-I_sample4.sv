module TopModule #(
    parameter POS = 0  // 0=LSB, 1=middle, 2=MSB
)(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    // Feedback generation logic
    wire feedback;
    generate
        if (POS == 2) begin
            // MSB gets XOR of q_in (q[1]) and Q (q[2])
            assign feedback = q_in ^ Q;
        end else begin
            // Other bits just pass through their input
            assign feedback = q_in;
        end
    endgenerate

    // Mux for load/shift selection
    wire mux_out = L ? r_in : feedback;

    // D flip-flop for storage
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule