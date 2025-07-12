module TopModule(
    input clk,
    input reset,
    input data,
    output start_shifting
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE = 3'b000,
    ONE = 3'b001,
    TWO = 3'b010,
    THREE = 3'b011,
    FINAL = 3'b100
} state, next_state;

// Assign start_shifting based on the current state
assign start_shifting = (state == FINAL) ? 1'b1 : 1'b0;

// FSM combinational logic
always_comb begin
    case (state)
        IDLE: begin
            if (data == 1'b1) begin
                next_state = ONE;
            end else begin
                next_state = IDLE;
            end
        end
        ONE: begin
            if (data == 1'b1) begin
                next_state = TWO;
            end else if (data == 1'b0) begin
                next_state = THREE;
            end else begin
                next_state = ONE;
            end
        end
        TWO: begin
            if (data == 1'b0) begin
                next_state = THREE;
            end else begin
                next_state = ONE;
            end
        end
        THREE: begin
            if (data == 1'b1) begin
                next_state = FINAL;
            end else begin
                next_state = IDLE;
            end
        end
        FINAL: begin
            next_state = FINAL;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// FSM sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule