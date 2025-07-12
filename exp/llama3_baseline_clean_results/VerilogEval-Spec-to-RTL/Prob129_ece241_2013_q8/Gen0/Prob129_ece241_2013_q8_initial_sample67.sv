module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

// Define the states
parameter IDLE = 2'b00;
parameter ONE = 2'b01;
parameter ZERO_AFTER_ONE = 2'b10;

// Declare the current and next states
reg [1:0] current_state;
reg [1:0] next_state;

// Initialize the current state
initial current_state = IDLE;

// Set the next state based on the current state and input x
always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Determine the next state
always @(*) begin
    case (current_state)
        IDLE: begin
            if (x) begin
                next_state = ONE;
            end else begin
                next_state = IDLE;
            end
        end
        ONE: begin
            if (~x) begin
                next_state = ZERO_AFTER_ONE;
            end else begin
                next_state = ONE;
            end
        end
        ZERO_AFTER_ONE: begin
            if (x) begin
                next_state = ONE;
            end else begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Determine the output z
assign z = (current_state == ZERO_AFTER_ONE) && x;

endmodule