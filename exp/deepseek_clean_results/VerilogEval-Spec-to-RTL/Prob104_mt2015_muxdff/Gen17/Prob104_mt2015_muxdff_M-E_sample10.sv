module TopModule #(parameter POS = 0) (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire feedback;

    // Position-specific feedback logic
    assign feedback = (POS == 0) ? (q_in ^ r_in) :  // q[2] ^ q[1]
                     (POS == 1) ? q_in :           // q[0]
                     Q;                             // q[2] (itself)

    always @(posedge clk) begin
        Q <= L ? r_in : feedback;
    end

endmodule