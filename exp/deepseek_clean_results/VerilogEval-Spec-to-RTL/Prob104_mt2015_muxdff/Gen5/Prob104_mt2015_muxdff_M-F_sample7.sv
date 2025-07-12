module TopModule #(
    parameter POSITION = 0
)(
    input clk,
    input L,
    input [1:0] q_in,  // [0] = q[0], [1] = q[1] (needed for feedback)
    input r_in,
    output reg Q
);

    wire feedback_value;
    
    // Position-specific feedback logic
    assign feedback_value = (POSITION == 0) ? (q_in[1] ^ Q) :  // q[1] ^ q[2]
                           (POSITION == 1) ? q_in[0] :          // q[0]
                           Q;                                  // q[2]

    always @(posedge clk) begin
        Q <= L ? r_in : feedback_value;
    end

endmodule