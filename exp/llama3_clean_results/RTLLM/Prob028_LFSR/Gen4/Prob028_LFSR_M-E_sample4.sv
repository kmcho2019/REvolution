// LFSR_Feedback module
module LFSR_Feedback(
    input [3:0] state,  // Current state of the LFSR
    output feedback     // Feedback value
);

assign feedback = ~(state[3] ^ state[2]);

endmodule

// LFSR_Shifter module
module LFSR_Shifter(
    input [3:0] state,  // Current state of the LFSR
    input feedback,    // Feedback value
    output reg [3:0] next_state  // Next state of the LFSR
);

always @ (*) begin
    next_state = {state[2:0], feedback};
end

endmodule

// LFSR_Controller module
module LFSR_Controller(
    input clk,  // Clock signal
    input rst,  // Active high reset signal
    output reg enable  // Enable signal for the LFSR
);

always @ (posedge clk) begin
    if (rst) begin
        enable <= 1'b0; // Reset the enable signal
    end else begin
        enable <= 1'b1; // Enable the LFSR
    end
end

endmodule

// Main LFSR module
module LFSR(
    input clk,  // Clock signal
    input rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

wire feedback;
reg [3:0] next_state;
reg enable;

LFSR_Controller controller(
    .clk(clk),
    .rst(rst),
    .enable(enable)
);

LFSR_Feedback feedback_module(
    .state(out),
    .feedback(feedback)
);

LFSR_Shifter shifter_module(
    .state(out),
    .feedback(feedback),
    .next_state(next_state)
);

always @ (posedge clk) begin
    if (rst) begin
        out <= 4'b0000; // Reset the LFSR to zero
    end else if (enable) begin
        out <= next_state; // Update the LFSR state
    end
end

endmodule