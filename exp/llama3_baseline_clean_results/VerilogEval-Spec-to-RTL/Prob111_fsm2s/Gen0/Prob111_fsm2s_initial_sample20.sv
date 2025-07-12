module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define the states
parameter OFF = 0;
parameter ON  = 1;

// Declare the current state and next state
reg [0:0] current_state;
reg [0:0] next_state;

// Initialize the current state to OFF
initial current_state = OFF;

// Always block for state transitions
always @ (posedge clk) begin
    if (reset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for next state and output
always @ (*) begin
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

    // Assign output based on current state
    case (current_state)
        OFF: out = 0;
        ON:  out = 1;
        default: out = 0;
    endcase
end

endmodule