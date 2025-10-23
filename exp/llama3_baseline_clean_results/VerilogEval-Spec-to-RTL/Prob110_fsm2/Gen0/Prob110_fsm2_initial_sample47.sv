module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

// Define the states
localparam OFF = 1'b0;
localparam ON = 1'b1;

// Define the current state and next state
reg current_state;
reg next_state;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

// Determine the next state based on the current state and inputs
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
    endcase
end

// Determine the output based on the current state
always @(*) begin
    case (current_state)
        OFF: out = 0;
        ON: out = 1;
    endcase
end

endmodule