module TopModule #(parameter POS = 0) (
    input clk,
    input L,
    input q_in,  // carries q[POS-1] for feedback
    input r_in,  // carries load value and q[POS+1] for feedback
    output reg Q
);

    wire feedback;

    // Position-specific feedback logic:
    // POS 0: q[1] ^ q[2] (r_in is q[1], q_in is q[2])
    // POS 1: q[0] (q_in is q[0])
    // POS 2: q[2] (itself)
    assign feedback = (POS == 0) ? (r_in ^ q_in) :
                     (POS == 1) ? q_in :
                     Q;

    always @(posedge clk) begin
        Q <= L ? r_in : feedback;
    end

endmodule