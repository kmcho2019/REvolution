module TopModule #(
    parameter POSITION = 0
)(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire feedback;

    // Position-specific feedback logic
    assign feedback = (POSITION == 0) ? (q_in ^ Q) :  // XOR for bit 0 (q[1]^q[2])
                     (POSITION == 1) ? q_in :        // Shift for bit 1 (q[0])
                     Q;                              // Hold for bit 2 (q[2])

    always @(posedge clk) begin
        Q <= L ? r_in : feedback;
    end

endmodule