module TopModule #(
    parameter POSITION = 0
)(
    input clk,
    input L,
    input q_in,        // Single bit input from adjacent cell
    input q_in_plus2,   // Additional input for position 0 only
    input r_in,
    output reg Q
);

    wire feedback;
    
    // Position-specific feedback logic
    assign feedback = (POSITION == 0) ? (q_in ^ q_in_plus2) :  // XOR for LSB
                     (POSITION == 1) ? q_in :                  // Middle bit
                     Q;                                        // MSB holds value

    always @(posedge clk) begin
        Q <= L ? r_in : feedback;
    end

endmodule