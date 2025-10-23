module sequence_detector (
    input  wire clk,
    input  wire reset_n,        // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot encoding of states (5 states)
    localparam IDLE = 5'b00001,
               S1   = 5'b00010,
               S2   = 5'b00100,
               S3   = 5'b01000,
               S4   = 5'b10000;

    reg [4:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case (1'b1)  // One-hot decoding style
            state[0]: begin // IDLE
                next_state = data_in ? S1 : IDLE;
            end
            state[1]: begin // S1 - detected '1'
                next_state = (data_in == 1'b0) ? S2 : S1; // '0' follows '1'
            end
            state[2]: begin // S2 - detected "10"
                next_state = (data_in == 1'b0) ? S3 : IDLE; // expect next '0'
            end
            state[3]: begin // S3 - detected "100"
                next_state = data_in ? S4 : IDLE; // expect final '1'
            end
            state[4]: begin // S4 - sequence detected "1001"
                // Allow overlapping sequences:
                next_state = data_in ? S1 : IDLE;
            end
            default: next_state = IDLE; // Safety fallback
        endcase
    end

    // Output logic: sequence_detected asserted only one clock cycle when in S4
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule