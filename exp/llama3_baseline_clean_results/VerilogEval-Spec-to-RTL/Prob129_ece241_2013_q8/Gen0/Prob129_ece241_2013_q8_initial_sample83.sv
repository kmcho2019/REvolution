module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Enumerate states
enum logic [1:0] {
    IDLE,
    ONE,
    ZERO_ONE
} state, next_state;

// Mealy-type FSM
always_ff @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        IDLE: begin
            if (x) begin
                next_state = ONE;
                z = 1'b0;
            end else begin
                next_state = IDLE;
                z = 1'b0;
            end
        end
        ONE: begin
            if (~x) begin
                next_state = ZERO_ONE;
                z = 1'b0;
            end else begin
                next_state = ONE;
                z = 1'b0;
            end
        end
        ZERO_ONE: begin
            if (x) begin
                next_state = ZERO_ONE;
                z = 1'b1;
            end else begin
                next_state = IDLE;
                z = 1'b0;
            end
        end
        default: begin
            next_state = IDLE;
            z = 1'b0;
        end
    endcase
end

endmodule