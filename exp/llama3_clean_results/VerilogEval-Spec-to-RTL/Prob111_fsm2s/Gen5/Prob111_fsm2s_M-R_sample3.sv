module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

// Define the states as an enumeration
enum {OFF, ON} state, next_state;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        case(state)
            OFF: begin
                if (j == 1'b1) begin
                    state <= ON;
                end else begin
                    state <= OFF;
                end
            end
            ON: begin
                if (k == 1'b1) begin
                    state <= OFF;
                end else begin
                    state <= ON;
                end
            end
        endcase
    end
end

// Output logic
always @(posedge clk) begin
    case(state)
        OFF: out <= 1'b0;
        ON:  out <= 1'b1;
    endcase
end

endmodule