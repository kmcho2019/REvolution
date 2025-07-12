module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // active low asynchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot state encoding for 5 states (IDLE, S1, S2, S3, S4)
    localparam IDLE = 5'b00001,
               S1   = 5'b00010,
               S2   = 5'b00100,
               S3   = 5'b01000,
               S4   = 5'b10000;

    reg [4:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1   : IDLE;
            S1:   next_state = data_in ? S1   : S2;
            S2:   next_state = data_in ? IDLE : S3;
            S3:   next_state = data_in ? S4   : IDLE;
            S4:   next_state = data_in ? S1   : IDLE; // supports overlapping
            default: next_state = IDLE;
        endcase
    end

    // State register with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // sequence_detected asserted when entering S4 (detected full 1001)
            // It can be asserted when state is S3 and data_in is 1 at next cycle
            sequence_detected <= (state == S3) && data_in;
        end
    end

endmodule