module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// State encoding (for readability)
localparam S0 = 2'b00;  // Strongly not-taken
localparam S1 = 2'b01;  // Weakly not-taken (reset state)
localparam S2 = 2'b10;  // Weakly taken
localparam S3 = 2'b11;  // Strongly taken

wire [1:0] next_state;

// Combinational next state logic
assign next_state = areset ? S1 :  // Async reset
                   train_valid ? 
                   (train_taken ? (state == S3 ? S3 : state + 1) :  // Increment with saturation
                                  (state == S0 ? S0 : state - 1)) :  // Decrement with saturation
                   state;  // Hold when not training

// Sequential state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= S1;
    end else begin
        state <= next_state;
    end
end

endmodule