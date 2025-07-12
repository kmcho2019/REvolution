module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    // Enum for states
    enum logic [0:0] {OFF, ON} state, next_state;

    // State transitions
    always @(*) begin
        case(state)
            OFF: begin
                if(j)
                    next_state = ON;
                else
                    next_state = OFF;
            end
            ON: begin
                if(k)
                    next_state = OFF;
                else
                    next_state = ON;
            end
            default: next_state = OFF;
        endcase
    end

    // Update state on clock edge
    always @(posedge clk or posedge areset) begin
        if(areset) begin
            state <= OFF;
            out <= 0;
        end else begin
            state <= next_state;
            if(state == OFF)
                out <= 0;
            else
                out <= 1;
        end
    end

endmodule