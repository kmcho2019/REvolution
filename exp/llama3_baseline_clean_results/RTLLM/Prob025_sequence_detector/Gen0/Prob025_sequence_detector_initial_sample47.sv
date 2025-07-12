module sequence_detector(
    input clk, 
    input reset_n, 
    input data_in, 
    output reg sequence_detected
);

// Define the states
typedef enum logic [2:0] {
    IDLE = 3'b001,
    S1 = 3'b010,
    S2 = 3'b011,
    S3 = 3'b100,
    S4 = 3'b101
} state_type;

// Declare the current and next state
reg [2:0] current_state;
reg [2:0] next_state;

// Initialize the sequence detected signal
initial sequence_detected = 0;

// Sequential logic
always @(posedge clk) begin
    if (!reset_n) begin
        // Reset to IDLE state when reset is high
        current_state <= IDLE;
        sequence_detected <= 0;
    end else begin
        // Update the current state
        current_state <= next_state;
        
        // Check if the sequence is detected and assert the sequence_detected signal
        if (current_state == S4) begin
            sequence_detected <= 1;
        end else begin
            sequence_detected <= 0;
        end
    end
end

// Combinational logic
always @* begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

endmodule