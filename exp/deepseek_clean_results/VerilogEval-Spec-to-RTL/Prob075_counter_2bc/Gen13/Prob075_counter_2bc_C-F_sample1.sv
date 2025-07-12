module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// State encoding
localparam S0 = 2'b00;  // Strongly not-taken
localparam S1 = 2'b01;  // Weakly not-taken (reset state)
localparam S2 = 2'b10;  // Weakly taken
localparam S3 = 2'b11;  // Strongly taken

wire [1:0] next_state;

// Next state calculation with saturation
assign next_state = areset ? S1 :  // Async reset
                   train_valid ? 
                   (train_taken ? (state == S3 ? S3 : state + 1) :  // Increment with saturation
                                 (state == S0 ? S0 : state - 1)) :  // Decrement with saturation
                   state;  // Hold when not training

// State register
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= S1;
    else
        state <= next_state;
end

endmodule