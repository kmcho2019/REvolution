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
    
    // Determine feedback based on position
    assign feedback = (POSITION == 0) ? (Q ^ q_in) :  // For position 0: q1 ^ q2
                     (POSITION == 1) ? q_in :         // For position 1: q0
                     q_in;                            // For position 2: q2
    
    always @(posedge clk) begin
        Q <= L ? r_in : feedback;
    end

endmodule