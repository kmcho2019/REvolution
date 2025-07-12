module TopModule #(
    parameter POSITION = 0
)(
    input clk,
    input L,
    input q0, q1, q2,  // All bits for feedback calculation
    input r_in,
    output reg Q
);

    wire feedback;
    
    // Determine feedback based on position
    assign feedback = (POSITION == 0) ? (q1 ^ q2) :
                     (POSITION == 1) ? q0 :
                     q2;  // Position 2
    
    always @(posedge clk) begin
        Q <= L ? r_in : feedback;
    end

endmodule