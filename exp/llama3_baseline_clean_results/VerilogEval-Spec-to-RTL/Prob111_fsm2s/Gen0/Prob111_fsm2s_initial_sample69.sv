module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define states
parameter OFF = 0, ON = 1;

// Declare current and next state variables
reg [0:0] current_state;
reg [0:0] next_state;

// Combinational logic for next state
always @(*) begin
    case (current_state)
        OFF: begin
            if (j)
                next_state = ON;
            else
                next_state = OFF;
        end
        ON: begin
            if (k)
                next_state = OFF;
            else
                next_state = ON;
        end
        default: next_state = OFF;
    endcase
end

// Sequential logic for state update
always @(posedge clk) begin
    if (reset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

// Output logic
assign out = (current_state == ON);

endmodule