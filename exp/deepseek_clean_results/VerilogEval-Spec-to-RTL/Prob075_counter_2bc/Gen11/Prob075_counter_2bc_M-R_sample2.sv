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

reg [1:0] next_state;

// Combinational next state logic
always_comb begin
    if (areset) begin
        next_state = S1;
    end
    else if (train_valid) begin
        case ({train_taken, state})
            // Increment cases
            {1'b1, S0}: next_state = S1;
            {1'b1, S1}: next_state = S2;
            {1'b1, S2}: next_state = S3;
            {1'b1, S3}: next_state = S3;  // Saturate at max
            
            // Decrement cases
            {1'b0, S0}: next_state = S0;  // Saturate at min
            {1'b0, S1}: next_state = S0;
            {1'b0, S2}: next_state = S1;
            {1'b0, S3}: next_state = S2;
        endcase
    end
    else begin
        next_state = state;  // Hold when not training
    end
end

// Sequential state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= S1;
    end else begin
        state <= next_state;
    end
end

endmodule