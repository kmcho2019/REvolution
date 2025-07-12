module TopModule #(
    parameter POSITION = 0
)(
    input clk,
    input L,
    input r_in,
    input q_right,      // Input from next higher position (position+1)
    input q_left,       // Input from next lower position (position-1)
    output reg Q
);

    wire feedback;

    // Position-specific feedback logic
    assign feedback = (POSITION == 0) ? (q_right ^ q_left) :  // XOR for LSB
                     (POSITION == 1) ? q_left :               // Middle bit
                     Q;                                      // MSB holds value

    always @(posedge clk) begin
        Q <= L ? r_in : feedback;
    end

endmodule