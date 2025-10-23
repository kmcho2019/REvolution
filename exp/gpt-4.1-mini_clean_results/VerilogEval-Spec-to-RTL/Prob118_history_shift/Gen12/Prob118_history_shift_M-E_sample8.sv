module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output [31:0]  predict_history
);

    // FSM states
    localparam IDLE   = 1'b0;
    localparam UPDATE = 1'b1;

    reg [31:0] history_reg;
    reg        state, next_state;

    // Default output
    assign predict_history = history_reg;

    // Next-state logic and output update
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (train_mispredicted)
                    next_state = UPDATE;
                else if (predict_valid)
                    next_state = UPDATE;
            end
            UPDATE: begin
                // After update, return to IDLE to wait for next event
                next_state = IDLE;
            end
        endcase
    end

    // Sequential logic: state update and history update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state       <= IDLE;
            history_reg <= 32'b0;
        end else begin
            state <= next_state;
            if (state == UPDATE) begin
                // On UPDATE state, apply priority logic:
                // If misprediction, load train_history + train_taken
                if (train_mispredicted) begin
                    // train_history is 32 bits for older branches, actual branch taken is LSB
                    // So history_reg[0] = train_taken (youngest), then train_history[31:0]
                    history_reg <= {train_history, 1'b0} | {31'b0, train_taken};
                end else if (predict_valid) begin
                    // Shift in predict_taken at LSB (youngest branch)
                    history_reg <= {history_reg[30:0], predict_taken};
                end
            end
            // Else no change in history_reg
        end
    end

endmodule