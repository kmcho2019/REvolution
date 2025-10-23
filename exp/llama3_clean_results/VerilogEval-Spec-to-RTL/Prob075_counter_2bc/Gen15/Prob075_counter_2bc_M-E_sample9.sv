module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] counter; // Two-bit counter
reg [1:0] next_counter; // Next state of the counter
reg fsm_state; // Finite state machine state (0: idle, 1: training)
reg next_fsm_state; // Next state of the FSM

// Combinational logic for the FSM
always @(*) begin
    next_fsm_state = fsm_state;
    if (areset) begin
        next_fsm_state = 1'b0; // Reset to idle state
    end else if (train_valid) begin
        next_fsm_state = 1'b1; // Move to training state
    end
end

// Combinational logic for the counter
always @(*) begin
    next_counter = counter;
    if (fsm_state == 1'b1) begin // Training state
        if (train_taken) begin
            if (counter == 2'b11) begin
                next_counter = 2'b11; // Saturate at maximum value
            end else begin
                next_counter = counter + 1;
            end
        end else begin
            if (counter == 2'b00) begin
                next_counter = 2'b00; // Saturate at minimum value
            end else begin
                next_counter = counter - 1;
            end
        end
    end
end

// Sequential logic to update the counter and FSM state
always @(posedge clk) begin
    if (areset) begin
        counter <= 2'b01; // Asynchronous reset
        fsm_state <= 1'b0;
    end else begin
        counter <= next_counter;
        fsm_state <= next_fsm_state;
    end
end

assign state = counter; // Output the counter value

endmodule