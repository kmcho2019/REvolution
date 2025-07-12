module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// State encoding
localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;
localparam S3 = 2'b11;

// Next state computation
wire [1:0] next_state_inc = (state == S3) ? S3 : (state + 1);
wire [1:0] next_state_dec = (state == S0) ? S0 : (state - 1);
wire [1:0] next_state_hold = state;

// Priority selection of next state
wire [1:0] next_state = 
    areset ? S1 :  // Async reset to weakly not-taken
    (train_valid & train_taken) ? next_state_inc :
    (train_valid & ~train_taken) ? next_state_dec :
    next_state_hold;

// State register with clock gating optimization
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= S1;
    else if (train_valid)  // Only update when needed
        state <= next_state;
end

endmodule