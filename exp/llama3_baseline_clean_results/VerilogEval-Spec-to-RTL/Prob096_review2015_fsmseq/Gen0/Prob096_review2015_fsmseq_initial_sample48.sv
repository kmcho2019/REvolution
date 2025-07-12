module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

// Define the states
enum logic [1:0] {IDLE, S1, S2, S3, FINAL} state, next_state;

// Output logic
assign start_shifting = (state == FINAL);

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (data) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (~data) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (data) begin
                next_state = FINAL;
            end else begin
                next_state = IDLE;
            end
        end
        FINAL: begin
            next_state = FINAL;
        end
        default: next_state = IDLE;
    endcase
end

endmodule