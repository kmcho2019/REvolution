module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Enumerating states
enum logic [2:0] {Idle, Got_1, Got_11, Got_110, Got_1101} state, nextState;

always_comb begin
    case(state)
        Idle: begin
            if (data) begin
                nextState = Got_1;
            end else begin
                nextState = Idle;
            end
        end
        Got_1: begin
            if (data) begin
                nextState = Got_11;
            end else begin
                nextState = Got_110; // Handling the case for sequence '1101'
            end
        end
        Got_11: begin
            if (data) begin
                nextState = Got_11;
            end else begin
                nextState = Got_110;
            end
        end
        Got_110: begin
            if (data) begin
                nextState = Got_1; // Incorrect sequence, revert to Got_1
            end else begin
                nextState = Got_1101;
            end
        end
        Got_1101: begin
            nextState = Got_1101;
        end
        default: begin
            nextState = Idle;
        end
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        start_shifting <= 0;
    end else begin
        state <= nextState;
        if (state == Got_1101) begin
            start_shifting <= 1;
        end else begin
            start_shifting <= 0;
        end
    end
end

endmodule