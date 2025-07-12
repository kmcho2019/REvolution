module sequence_detector (
    input  wire clk,
    input  wire rst_n,           // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (3 bits)
    localparam IDLE = 3'd0,
               S1   = 3'd1,
               S2   = 3'd2,
               S3   = 3'd3,
               S4   = 3'd4;

    reg [2:0] state, next_state;

    // Next-state combinational logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;              // Wait for first '1'
            S1:   next_state = data_in ? S1 : S2;                // Matched '1', next '0' for S2 or stay if '1'
            S2:   next_state = data_in ? S1 : S3;                // Matched '10', next '0' for S3 or restart if '1'
            S3:   next_state = data_in ? S4 : IDLE;              // Matched '100', next '1' completes seq or reset
            S4:   next_state = data_in ? S1 : IDLE;              // After detection, allow overlapping sequences
            default: next_state = IDLE;
        endcase
    end

    // Sequential state and output registers with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Assert output only when entering detection state S4
            sequence_detected <= (next_state == S4);
        end
    end

endmodule