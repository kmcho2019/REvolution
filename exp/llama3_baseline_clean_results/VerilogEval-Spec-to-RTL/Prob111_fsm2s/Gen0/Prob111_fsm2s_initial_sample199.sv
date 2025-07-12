module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state;
reg [1:0] nextState;

// Define the states
parameter OFF = 2'b00;
parameter ON  = 2'b01;

// Determine the next state
always @(*) begin
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
        default: nextState = OFF;
    endcase
end

// Update the state on clock edge
always @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= nextState;
    end
end

// Determine the output
always @(*) begin
    case (state)
        OFF: out <= 0;
        ON: out <= 1;
        default: out <= 0;
    endcase
end

endmodule