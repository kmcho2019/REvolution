// Define the feedback generator module
module feedback_generator(
    input [3:0] state,
    output reg feedback
);

    // Calculate the feedback as the XOR of the most significant and second most significant bits, then invert
    always @(*) begin
        feedback = ~(state[3] ^ state[2]);
    end

endmodule

// Define the LFSR module
module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

    // Instantiate the feedback generator
    wire feedback;
    feedback_generator fg(
        .state(out),
        .feedback(feedback)
    );

    // Update the LFSR state on the rising edge of the clock
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the LFSR to zero
            out <= 4'b0;
        end else begin
            // Shift the bits left and insert the new feedback value at the LSB
            out <= {out[2:0], feedback};
        end
    end

endmodule