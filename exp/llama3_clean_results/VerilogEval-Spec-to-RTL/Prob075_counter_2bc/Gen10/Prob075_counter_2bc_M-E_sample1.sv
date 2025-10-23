module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the FSM state
assign state = state_reg; // Continuous assignment to output the state

// Define the states
localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;
localparam S3 = 2'b11;

// Sequential logic to update the state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= S1; // Asynchronous reset to S1 (weakly not-taken)
    end else begin
        case (state_reg)
            S0: begin
                if (train_valid && train_taken) begin
                    state_reg <= S1; // Transition to S1
                end else begin
                    state_reg <= S0; // Stay in S0
                end
            end
            S1: begin
                if (train_valid && train_taken) begin
                    state_reg <= S2; // Transition to S2
                end else if (train_valid && !train_taken) begin
                    state_reg <= S0; // Transition to S0
                end else begin
                    state_reg <= S1; // Stay in S1
                end
            end
            S2: begin
                if (train_valid && train_taken) begin
                    state_reg <= S3; // Transition to S3
                end else if (train_valid && !train_taken) begin
                    state_reg <= S1; // Transition to S1
                end else begin
                    state_reg <= S2; // Stay in S2
                end
            end
            S3: begin
                if (train_valid && !train_taken) begin
                    state_reg <= S2; // Transition to S2
                end else begin
                    state_reg <= S3; // Stay in S3
                end
            end
            default: begin
                state_reg <= S1; // Default to S1
            end
        endcase
    end
end

endmodule