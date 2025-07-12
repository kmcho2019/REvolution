module TopModule #(parameter POS = 0) (
    input clk,
    input L,
    input q_in,
    input r_in,
    input q0,    // For position 2 feedback calculation
    input q1,    // For position 2 feedback calculation
    output reg Q
);

    wire feedback;
    
    // Determine feedback based on bit position
    assign feedback = (POS == 0) ? q1 :         // q[0] gets q[2]
                     (POS == 1) ? q0 :         // q[1] gets q[0]
                     (q0 ^ q1);                 // q[2] gets q[1]^q[2]

    always @(posedge clk) begin
        Q <= L ? r_in : feedback;
    end

endmodule