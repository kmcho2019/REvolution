module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE,
    ONES,
    FLAG,
    DISC,
    ERR
} state, next_state;

// Define a counter to keep track of consecutive ones
logic [2:0] ones_count;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        ones_count <= 3'b000;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= next_state;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
        
        case (state)
            IDLE: begin
                if (in) begin
                    state <= ONES;
                    ones_count <= 1;
                end else begin
                    state <= IDLE;
                end
            end
            ONES: begin
                if (in) begin
                    ones_count <= ones_count + 1;
                    if (ones_count == 5) begin
                        state <= DISC;
                    end else if (ones_count > 5) begin
                        state <= FLAG;
                        flag <= 1'b1;
                    end else begin
                        state <= ONES;
                    end
                end else begin
                    if (ones_count == 5) begin
                        state <= ERR;
                        err <= 1'b1;
                    end else if (ones_count < 5) begin
                        state <= IDLE;
                    end else begin
                        state <= IDLE;
                    end
                end
            end
            FLAG: begin
                flag <= 1'b1;
                state <= IDLE;
            end
            DISC: begin
                disc <= 1'b1;
                state <= IDLE;
            end
            ERR: begin
                err <= 1'b1;
                state <= IDLE;
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule