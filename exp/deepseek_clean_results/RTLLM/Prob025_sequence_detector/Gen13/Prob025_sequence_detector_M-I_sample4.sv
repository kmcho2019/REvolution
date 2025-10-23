module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// One-hot encoded states
localparam IDLE = 3'b000;
localparam S1   = 3'b001;  // Received '1'
localparam S2   = 3'b010;  // Received '10'
localparam S3   = 3'b100;  // Received '100'

reg [2:0] current_state, next_state;
reg clk_enable;  // Clock gating control

// Clock gating logic: Only enable when not in IDLE or when receiving relevant bits
always @(*) begin
    clk_enable = (current_state != IDLE) || data_in;
end

// State transition logic
always @(*) begin
    case (current_state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:   next_state = data_in ? S1 : S2;
        S2:   next_state = data_in ? S1 : S3;
        S3:   next_state = data_in ? S1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// State register with gated clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
    end else if (clk_enable) begin
        current_state <= next_state;
    end
end

// Detection logic pipelined into two stages
reg stage1_match;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_match <= 1'b0;
        sequence_detected <= 1'b0;
    end else begin
        // First stage: detect '100' pattern
        stage1_match <= (current_state == S3);
        // Second stage: combine with final '1'
        sequence_detected <= stage1_match && data_in;
    end
end

endmodule