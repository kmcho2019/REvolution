module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    localparam IDLE = 3'd0,
               S1   = 3'd1,  // detected '1'
               S2   = 3'd2,  // detected '10'
               S3   = 3'd3,  // detected '100'
               S4   = 3'd4;  // detected '1001' (sequence complete)

    reg [2:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = (data_in == 1'b0) ? S2 : S1;
            S2:   next_state = (data_in == 1'b0) ? S3 : S1;
            S3:   next_state = data_in ? S4 : IDLE;
            S4:   next_state = data_in ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State update and output logic
    always @(posedge clk) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            sequence_detected <= (state == S3) && (data_in == 1'b1);
        end
    end

endmodule