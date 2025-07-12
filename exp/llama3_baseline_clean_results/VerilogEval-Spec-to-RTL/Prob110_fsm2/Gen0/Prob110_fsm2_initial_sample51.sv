module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// Define the states
parameter OFF = 1'b0;
parameter ON = 1'b1;

reg current_state;
reg next_state;

// Always block for asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        // Asynchronous reset to OFF state
        current_state <= OFF;
    end else begin
        // Synchronous state transitions
        current_state <= next_state;
    end
end

// Combinational logic to determine next state
always @(*) begin
    case (current_state)
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

// Output is directly related to the current state
assign out = current_state;

endmodule