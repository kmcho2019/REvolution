module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

// Define the states as an enum
enum logic [0:0] {OFF, ON} state, next_state;

// Sequential logic to update the state
always @ (posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Combinational logic to determine the next state
always @ (*) begin
    case (state)
        OFF: begin
            if (j) begin
                next_state <= ON;
            end else begin
                next_state <= OFF;
            end
        end
        ON: begin
            if (k) begin
                next_state <= OFF;
            end else begin
                next_state <= ON;
            end
        end
    endcase
end

// Output logic
always @ (*) begin
    case (state)
        OFF: out <= 0;
        ON: out <= 1;
    endcase
end

endmodule