module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (binary)
    localparam [2:0]
        IDLE = 3'd0,
        S1   = 3'd1,   // matched '1'
        S2   = 3'd2,   // matched '10'
        S3   = 3'd3,   // matched '100'
        S4   = 3'd4;   // matched '1001' (detection)

    reg [2:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S4 : IDLE;
            S4:   next_state = data_in ? S1 : S2; // allow overlapping sequences
            default: next_state = IDLE;
        endcase
    end

    // State register and output logic with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // sequence_detected asserted when state machine just entered S4
            // That is, when current next_state is S4, sequence_detected should be 1 in next cycle
            // Since we update state first, use next_state logic to assert output on next cycle
            sequence_detected <= (next_state == S4);
        end
    end

endmodule