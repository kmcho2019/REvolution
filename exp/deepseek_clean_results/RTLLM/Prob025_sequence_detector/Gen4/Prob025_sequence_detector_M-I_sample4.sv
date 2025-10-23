module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// One-hot state encoding
parameter [3:0] IDLE   = 4'b0001;
parameter [3:0] S1     = 4'b0010;
parameter [3:0] S2     = 4'b0100;
parameter [3:0] S3     = 4'b1000;

reg [3:0] current_state, next_state;

// State transition logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state and output logic
always @(*) begin
    sequence_detected = 1'b0;
    next_state = IDLE; // Default
    
    case (current_state)
        IDLE: begin
            if (data_in) next_state = S1;
            else next_state = IDLE;
        end
        S1: begin
            if (!data_in) next_state = S2;
            else next_state = S1;
        end
        S2: begin
            if (!data_in) next_state = S3;
            else next_state = S1;
        end
        S3: begin
            if (data_in) begin
                sequence_detected = 1'b1;
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule