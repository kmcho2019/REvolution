module TopModule (
    input       clk,
    input       areset,
    input       j,
    input       k,
    output      out
);

// Define the states
enum logic [0:0] {OFF, ON} state, next_state;

// Output is determined by the state
assign out = (state == ON) ? 1'b1 : 1'b0;

// State machine logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF; // Asynchronous reset to state OFF
    end else begin
        case (state)
            OFF: begin
                if (j) begin
                    state <= ON;
                end else begin
                    state <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF;
                end else begin
                    state <= ON;
                end
            end
            default: state <= OFF; // Default state if not specified
        endcase
    end
end

endmodule