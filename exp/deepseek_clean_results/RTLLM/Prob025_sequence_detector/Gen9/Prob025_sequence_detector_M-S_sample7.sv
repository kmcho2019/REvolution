module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// State encoding
localparam IDLE = 2'b00;
localparam S1   = 2'b01;  // Received '1'
localparam S2   = 2'b10;  // Received '10'
localparam S3   = 2'b11;  // Received '100'

reg [1:0] state, next_state;

// State transition and output logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end
    else begin
        state <= next_state;
        // Output is high only when we detect the complete sequence
        sequence_detected <= (next_state == S3) && data_in;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:   next_state = data_in ? S1 : S2;
        S2:   next_state = data_in ? S3 : IDLE;
        S3:   next_state = data_in ? S1 : S2;
        default: next_state = IDLE;
    endcase
end

endmodule