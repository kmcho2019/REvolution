module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

// Define the states
localparam IDLE = 2'b00;
localparam S1   = 2'b01;
localparam S2   = 2'b10;
localparam S3   = 2'b11;

// Declare the current state
reg [1:0] current_state;

// Assign the initial state
initial current_state = IDLE;

// State transition logic
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    current_state <= S1;
                    sequence_detected <= 1'b0;
                end else begin
                    current_state <= IDLE;
                    sequence_detected <= 1'b0;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin
                    current_state <= S2;
                    sequence_detected <= 1'b0;
                end else begin
                    current_state <= IDLE; // Reset to IDLE if the sequence is not matched
                    sequence_detected <= 1'b0;
                end
            end
            S2: begin
                if (data_in == 1'b0) begin
                    current_state <= S3;
                    sequence_detected <= 1'b0;
                end else begin
                    current_state <= IDLE; // Reset to IDLE if the sequence is not matched
                    sequence_detected <= 1'b0;
                end
            end
            S3: begin
                if (data_in == 1'b1) begin
                    sequence_detected <= 1'b1; // Set sequence_detected to 1'b1 when the sequence is detected
                    current_state <= IDLE; // Reset to IDLE after detecting the sequence
                end else begin
                    current_state <= IDLE; // Reset to IDLE if the sequence is not matched
                    sequence_detected <= 1'b0;
                end
            end
            default: begin
                current_state <= IDLE;
                sequence_detected <= 1'b0;
            end
        endcase
    end
end

endmodule