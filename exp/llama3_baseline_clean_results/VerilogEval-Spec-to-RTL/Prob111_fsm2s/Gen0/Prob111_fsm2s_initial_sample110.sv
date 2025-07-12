module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Enumerate states
enum logic [0:0] {OFF, ON} current_state, next_state;

// Clocked always block for state transition and reset
always_ff @(posedge clk) begin
    if(reset) begin
        current_state <= OFF;
    end else begin
        case(current_state)
            OFF: begin
                if(j) begin
                    current_state <= ON;
                end else begin
                    current_state <= OFF;
                end
            end
            ON: begin
                if(k) begin
                    current_state <= OFF;
                end else begin
                    current_state <= ON;
                end
            end
        endcase
    end
end

// Output logic based on current state
always_comb begin
    case(current_state)
        OFF: out = 0;
        ON: out = 1;
    endcase
end

endmodule