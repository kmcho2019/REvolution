module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Pattern storage
localparam PATTERN = 4'b1001;

// 4-bit input window
reg [3:0] input_window;

// Parallel comparators
wire [3:0] match_bits;
assign match_bits[0] = (input_window[3:0] == PATTERN);
assign match_bits[1] = (input_window[2:0] == PATTERN[3:1]) & (data_in == PATTERN[0]);
assign match_bits[2] = (input_window[1:0] == PATTERN[3:2]) & ({data_in, 1'b0} == PATTERN[1:0]);
assign match_bits[3] = (input_window[0] == PATTERN[3]) & ({data_in, 2'b00} == PATTERN[2:0]);

// Early termination logic
wire any_match = |match_bits;
wire early_terminate = !any_match && (input_window != 4'b0);

// Confidence counter (3 consecutive matches required)
reg [1:0] confidence;
wire detection_valid = (confidence == 2'b11);

// Gray-coded state machine
reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        input_window <= 4'b0;
        sequence_detected <= 1'b0;
        confidence <= 2'b0;
        state <= 2'b00;
    end else begin
        // Update input window
        input_window <= {input_window[2:0], data_in};
        
        // State transition with gray coding
        state <= next_state;
        
        // Confidence counting
        if (any_match) begin
            confidence <= (detection_valid) ? 2'b11 : (confidence + 1'b1);
        end else if (early_terminate) begin
            confidence <= 2'b0;
        end
        
        // Registered output
        sequence_detected <= detection_valid && any_match;
    end
end

// Next state logic (gray coded)
always @(*) begin
    case (state)
        2'b00: next_state = (any_match) ? 2'b01 : 2'b00;
        2'b01: next_state = (any_match) ? 2'b11 : 2'b00;
        2'b11: next_state = (any_match) ? 2'b10 : 2'b00;
        2'b10: next_state = (any_match) ? 2'b00 : 2'b00;
        default: next_state = 2'b00;
    endcase
end

endmodule