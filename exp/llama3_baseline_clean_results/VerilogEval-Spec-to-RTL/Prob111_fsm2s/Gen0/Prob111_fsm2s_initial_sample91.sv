module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define the states
enum logic [0:0] {OFF, ON} state, next_state;

// State register process
always_ff @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Next state logic process
always_comb begin
    case (state)
        OFF: begin
            if (j) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if (k) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: next_state = OFF;
    endcase
end

// Output logic process
always_comb begin
    case (state)
        OFF: out = 0;
        ON: out = 1;
        default: out = 0;
    endcase
end

endmodule