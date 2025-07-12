module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// State encoding
localparam [1:0] IDLE = 2'b00,
                 S1   = 2'b01,  // Received '1'
                 S2   = 2'b10,  // Received '10'
                 S3   = 2'b11;  // Received '100'

reg [1:0] current_state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        sequence_detected <= (next_state == S3) && data_in;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:   next_state = data_in ? S1 : S2;
        S2:   next_state = data_in ? S3 : IDLE;
        S3:   next_state = data_in ? S1 : S2;
        default: next_state = IDLE;
    endcase
end

endmodule