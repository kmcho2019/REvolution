module TopModule(
    input clk,  // Clock signal
    input w,    // Input from the previous stage
    input R,    // Value to load
    input E,    // Enable shift
    input L,    // Load signal
    output Q    // Output of the module
);

reg q_reg;  // Register to store the current value
reg [1:0] state;  // State variable for the FSM

// Define states
parameter IDLE = 2'b00;
parameter LOAD = 2'b01;
parameter SHIFT = 2'b10;

always @(posedge clk) begin
    case (state)
        IDLE: begin
            if (L) begin
                q_reg <= R;
                state <= LOAD;
            end else if (E) begin
                q_reg <= w;
                state <= SHIFT;
            end
        end
        LOAD: begin
            state <= IDLE;
        end
        SHIFT: begin
            state <= IDLE;
        end
        default: state <= IDLE;
    endcase
end

assign Q = q_reg;  // Continuous assignment to output the current value

initial begin
    state <= IDLE;  // Initialize the state to IDLE
end

endmodule