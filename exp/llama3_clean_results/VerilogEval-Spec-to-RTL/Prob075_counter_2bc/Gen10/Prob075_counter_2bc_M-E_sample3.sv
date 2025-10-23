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
localparam IDLE = 2'b00;
localparam LOW = 2'b01;
localparam MIDDLE = 2'b10;
localparam HIGH = 2'b11;

// Sequential logic to update the state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= LOW; // Asynchronous reset to the LOW state
    end else begin
        case (state_reg)
            IDLE: begin
                if (train_valid && train_taken) begin
                    state_reg <= LOW; // Transition to LOW if train_valid and train_taken are high
                end else if (train_valid && !train_taken) begin
                    state_reg <= IDLE; // Remain in IDLE if train_valid is high and train_taken is low
                end else begin
                    state_reg <= IDLE; // Remain in IDLE if train_valid is low
                end
            end
            LOW: begin
                if (train_valid && train_taken) begin
                    state_reg <= MIDDLE; // Transition to MIDDLE if train_valid and train_taken are high
                end else if (train_valid && !train_taken) begin
                    state_reg <= IDLE; // Transition to IDLE if train_valid is high and train_taken is low
                end else begin
                    state_reg <= LOW; // Remain in LOW if train_valid is low
                end
            end
            MIDDLE: begin
                if (train_valid && train_taken) begin
                    state_reg <= HIGH; // Transition to HIGH if train_valid and train_taken are high
                end else if (train_valid && !train_taken) begin
                    state_reg <= LOW; // Transition to LOW if train_valid is high and train_taken is low
                end else begin
                    state_reg <= MIDDLE; // Remain in MIDDLE if train_valid is low
                end
            end
            HIGH: begin
                if (train_valid && train_taken) begin
                    state_reg <= HIGH; // Remain in HIGH if train_valid and train_taken are high
                end else if (train_valid && !train_taken) begin
                    state_reg <= MIDDLE; // Transition to MIDDLE if train_valid is high and train_taken is low
                end else begin
                    state_reg <= HIGH; // Remain in HIGH if train_valid is low
                end
            end
            default: begin
                state_reg <= IDLE; // Default to IDLE state
            end
        endcase
    end
end

endmodule