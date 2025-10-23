module sequence_detector (
    input  wire clk,
    input  wire reset_n,        // Active-low asynchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding using localparam
    localparam IDLE = 3'd0,
               S1   = 3'd1,  // matched '1'
               S2   = 3'd2,  // matched '10'
               S3   = 3'd3,  // matched '100'
               S4   = 3'd4;  // matched '1001' (final)

    reg [2:0] current_state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (current_state)
            IDLE:  next_state = (data_in == 1'b1) ? S1 : IDLE;
            S1:    next_state = (data_in == 1'b0) ? S2 : S1;
            S2:    next_state = (data_in == 1'b0) ? S3 : IDLE;
            S3:    next_state = (data_in == 1'b1) ? S4 : S2;
            S4:    next_state = (data_in == 1'b1) ? S1 : S2;
            default: next_state = IDLE;
        endcase
    end

    // State register with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            current_state <= next_state;
            // Moore output: assert when in S4 state
            sequence_detected <= (next_state == S4);
        end
    end

endmodule