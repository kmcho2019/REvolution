module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

// Define the states
enum logic [0:0] {OFF, ON} state, next_state;

// Synchronous reset
always @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// State transition logic
always @(*) begin
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
always @(*) begin
    case (state)
        OFF: out <= 0;
        ON: out <= 1;
    endcase
end

endmodule