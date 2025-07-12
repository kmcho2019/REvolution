module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// Gray-coded state definitions
localparam [1:0] 
    IDLE = 2'b00,
    S1   = 2'b01,
    S2   = 2'b11,
    S3   = 2'b10;

reg [1:0] current_state, next_state;

// State transition logic with predictive advancement
always @(*) begin
    case (current_state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:   next_state = data_in ? S1 : S2;  // If we get another 1, stay in S1
        S2:   next_state = data_in ? S3 : IDLE;
        S3:   next_state = data_in ? S1 : S2;  // Special case for overlap
        default: next_state = IDLE;
    endcase
end

// Output logic (Mealy-style)
always @(*) begin
    sequence_detected = (current_state == S3) && !data_in;
end

// State register with Gray coding
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

endmodule