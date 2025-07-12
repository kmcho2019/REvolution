module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Enum for states
enum logic [0:0] {OFF, ON} state, nextState;

// State register
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= nextState;
    end
end

// Next state logic
always_comb begin
    case (state)
        OFF: begin
            if (j) begin
                nextState = ON;
            end else begin
                nextState = OFF;
            end
        end
        ON: begin
            if (k) begin
                nextState = OFF;
            end else begin
                nextState = ON;
            end
        end
        default: begin
            nextState = OFF; // Default state if not explicitly handled
        end
    endcase
end

// Output logic
assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule