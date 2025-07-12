module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output reg      sequence_detected
);

// Define the states
localparam IDLE    = 2'b00;
localparam S1      = 2'b01;
localparam S2      = 2'b10;
localparam S3      = 2'b11;
localparam S4      = 2'b00; // Define the state for the final bit of the sequence

// Declare the current state
reg [1:0] current_state;

// Assign the initial state
initial current_state = IDLE;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    current_state <= S1;
                end else begin
                    current_state <= IDLE;
                end
                sequence_detected <= 1'b0;
            end
            S1: begin
                if (data_in == 1'b0) begin
                    current_state <= S2;
                end else begin
                    current_state <= IDLE;
                end
                sequence_detected <= 1'b0;
            end
            S2: begin
                if (data_in == 1'b0) begin
                    current_state <= S3;
                end else begin
                    current_state <= IDLE;
                end
                sequence_detected <= 1'b0;
            end
            S3: begin
                if (data_in == 1'b1) begin
                    current_state <= S4; // Move to the new state for the final bit
                    sequence_detected <= 1'b1;
                end else begin
                    current_state <= IDLE;
                    sequence_detected <= 1'b0;
                end
            end
            S4: begin
                current_state <= IDLE; // Reset the state machine after detection
                sequence_detected <= 1'b0;
            end
            default: begin
                current_state <= IDLE;
                sequence_detected <= 1'b0;
            end
        endcase
    end
end

endmodule