module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// State encoding
parameter IDLE = 3'd0;
parameter S1   = 3'd1;  // Received '1'
parameter S2   = 3'd2;  // Received '10'
parameter S3   = 3'd3;  // Received '100'
parameter S4   = 3'd4;  // Received '1001' (detected)

reg [2:0] current_state, next_state;

// State transition logic (combinational)
always @(*) begin
    case (current_state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:   next_state = data_in ? S1 : S2;
        S2:   next_state = data_in ? S1 : S3;
        S3:   next_state = data_in ? S4 : IDLE;
        S4:   next_state = data_in ? S1 : S2;
        default: next_state = IDLE;
    endcase
end

// State register and output (sequential)
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        sequence_detected <= (next_state == S4);
    end
end

endmodule