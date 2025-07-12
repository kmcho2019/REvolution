module TopModule #(
    parameter POSITION = 0
)(
    input clk,
    input L,
    input q_in,        // Input from adjacent cell (q[0] for POSITION=1, q[1] for POSITION=0)
    input q_in2,       // Second input needed for POSITION=0 (q[2])
    input r_in,
    output Q
);

    reg q_reg;
    wire feedback;

    // Position-specific feedback logic
    assign feedback = (POSITION == 0) ? (q_in ^ q_in2) :  // q[1] ^ q[2] for position 0
                     (POSITION == 1) ? q_in :             // q[0] for position 1
                     q_reg;                              // q[2] for position 2 (hold its value)

    always @(posedge clk) begin
        q_reg <= L ? r_in : feedback;
    end

    assign Q = q_reg;

endmodule