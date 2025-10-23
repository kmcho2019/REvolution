module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    localparam IDLE = 2'd0,
               S1   = 2'd1, // matched '1'
               S2   = 2'd2, // matched '10'
               S3   = 2'd3; // matched '100'

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S1 : IDLE; // if '1', sequence complete next clock
            default: next_state = IDLE;
        endcase
    end

    // State and output update
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            sequence_detected <= (state == S3) && data_in; // detect '1001'
            state <= next_state;
        end
    end

endmodule