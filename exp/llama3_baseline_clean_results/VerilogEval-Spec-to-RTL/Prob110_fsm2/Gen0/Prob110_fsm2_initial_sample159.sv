module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

// Define states
enum logic [0:0] {OFF, ON} state, nextState;

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
    end else begin
        state <= nextState;
    end
end

// Next state logic
always @(*) begin
    case(state)
        OFF: begin
            if (j) begin
                nextState <= ON;
            end else begin
                nextState <= OFF;
            end
        end
        ON: begin
            if (k) begin
                nextState <= OFF;
            end else begin
                nextState <= ON;
            end
        end
        default: nextState <= OFF; // default to OFF in case of an invalid state
    endcase
end

// Output logic
always @(*) begin
    case(state)
        OFF: out <= 1'b0;
        ON: out <= 1'b1;
        default: out <= 1'b0; // default output to 0 in case of an invalid state
    endcase
end

endmodule