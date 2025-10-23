module TopModule #(
    parameter POSITION = 0
)(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire next_state;

    // Position-specific next state logic
    assign next_state = L ? r_in : 
                       (POSITION == 0) ? (q_in ^ Q) :  // XOR for position 0
                       (POSITION == 1) ? q_in :        // Shift for position 1
                       Q;                               // Hold for position 2

    always @(posedge clk) begin
        Q <= next_state;
    end

endmodule