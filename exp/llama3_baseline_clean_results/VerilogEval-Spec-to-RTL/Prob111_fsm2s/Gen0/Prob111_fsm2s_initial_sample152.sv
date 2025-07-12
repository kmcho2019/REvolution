module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define the states
parameter OFF = 1'b0;
parameter ON = 1'b1;

// Declare the current state and next state
reg current_state;
reg next_state;

// Define the output based on the current state
always @(*) begin
    case(current_state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
    endcase
end

// Define the state transitions
always @(*) begin
    case(current_state)
        OFF: begin
            if(j == 1'b1) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if(k == 1'b1) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
    endcase
end

// Update the current state on the rising edge of the clock
always @(posedge clk) begin
    if(reset == 1'b1) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

endmodule