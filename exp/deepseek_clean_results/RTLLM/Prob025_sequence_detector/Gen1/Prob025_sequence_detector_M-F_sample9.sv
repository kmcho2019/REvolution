module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define states as parameters
parameter [2:0] 
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100;

// State registers
reg [2:0] current_state, next_state;

// State transition logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: next_state = (data_in == 1'b1) ? S1 : IDLE;
        S1:   next_state = (data_in == 1'b0) ? S2 : S1;
        S2:   next_state = (data_in == 1'b0) ? S3 : S1;
        S3:   next_state = (data_in == 1'b1) ? S4 : IDLE;
        S4:   next_state = (data_in == 1'b1) ? S1 : S2;
        default: next_state = IDLE;
    endcase
end

// Output logic (Moore style)
always @(*) begin
    sequence_detected = (current_state == S4);
end

endmodule