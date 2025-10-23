module TopModule #(parameter POS = 0) (
    input clk,
    input L,
    input q0_in,  // q[0] value
    input q1_in,  // q[1] value
    input q2_in,  // q[2] value
    input r_in,
    output reg Q
);

    wire feedback;

    // Position-specific feedback logic
    assign feedback = (POS == 0) ? (q1_in ^ q2_in) :  // q[1] ^ q[2]
                     (POS == 1) ? q0_in :            // q[0]
                     q2_in;                           // q[2]

    always @(posedge clk) begin
        Q <= L ? r_in : feedback;
    end

endmodule