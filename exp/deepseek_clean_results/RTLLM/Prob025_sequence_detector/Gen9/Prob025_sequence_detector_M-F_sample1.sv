module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// State encoding
parameter IDLE = 2'b00;
parameter S1   = 2'b01;
parameter S2   = 2'b10;
parameter S3   = 2'b11;

reg [1:0] current_state, next_state;

// State transition logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: next_state = (data_in == 1'b1) ? S1 : IDLE;
        S1:   next_state = (data_in == 1'b0) ? S2 : S1;
        S2:   next_state = (data_in == 1'b0) ? S3 : IDLE;
        S3:   next_state = (data_in == 1'b1) ? S1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// Output logic
always @(*) begin
    sequence_detected = (current_state == S3) && (data_in == 1'b1);
end

endmodule