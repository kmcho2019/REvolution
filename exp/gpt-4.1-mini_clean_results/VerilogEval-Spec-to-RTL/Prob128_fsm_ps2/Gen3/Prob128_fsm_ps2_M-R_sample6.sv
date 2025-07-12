module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum reg [1:0] {IDLE=2'd0, COUNT1=2'd1, COUNT2=2'd2} state_t;
    state_t state, next_state;

    // Next state and done combinational logic
    always @(*) begin
        done = 1'b0;
        case (state)
            IDLE: begin
                if (in[3])
                    next_state = COUNT1;
                else
                    next_state = IDLE;
            end
            COUNT1: next_state = COUNT2;
            COUNT2: begin
                next_state = IDLE;
                done = 1'b1; // Assert done after third byte
            end
            default: begin
                next_state = IDLE;
                done = 1'b0;
            end
        endcase
    end

    // State update on clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

endmodule