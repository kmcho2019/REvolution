module sequence_detector (
    input  wire clk,
    input  wire rst_n,           // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // FSM state encoding (3 bits for 5 states)
    localparam IDLE = 3'd0,
               S1   = 3'd1,   // detected '1'
               S2   = 3'd2,   // detected "10"
               S3   = 3'd3,   // detected "100"
               S4   = 3'd4;   // detected "1001" (final state)

    reg [2:0] state, next_state;

    // Combinational logic: Next state determination
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;                // Wait for first '1'
            S1:   next_state = (data_in == 1'b0) ? S2 : S1;        // matched '1', then '0' or stay if '1'
            S2:   next_state = (data_in == 1'b0) ? S3 : S1;        // matched "10", next '0' or restart on '1'
            S3:   next_state = data_in ? S4 : IDLE;                // matched "100", '1' completes seq else restart
            S4:   next_state = data_in ? S1 : IDLE;                // detected sequence, allow overlapping
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: State and output update with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Assert sequence_detected for one cycle when entering S4 (Moore output)
            sequence_detected <= (next_state == S4);
        end
    end

endmodule