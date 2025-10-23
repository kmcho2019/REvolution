module TopModule #(
    parameter POS = 0  // 0=LSB, 1=middle, 2=MSB
)(
    input clk,
    input L,
    input q_in,  // Feedback input from other flip-flops
    input r_in,   // Load input
    output reg Q  // Output state
);

    // Position-specific feedback logic
    wire feedback;
    generate
        if (POS == 2) begin  // MSB: q[1] ^ q[2]
            assign feedback = q_in ^ Q;
        end
        else if (POS == 1) begin  // Middle: q[0]
            assign feedback = q_in;
        end
        else begin  // LSB: q[2]
            assign feedback = Q;
        end
    endgenerate

    // Load vs feedback selection
    wire next_state = L ? r_in : feedback;

    // State register
    always @(posedge clk) begin
        Q <= next_state;
    end

endmodule