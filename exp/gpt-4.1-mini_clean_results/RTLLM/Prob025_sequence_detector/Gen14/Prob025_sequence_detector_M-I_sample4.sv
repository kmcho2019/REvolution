module sequence_detector (
    input  wire clk,
    input  wire rst_n,           // Active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot state encoding
    localparam IDLE = 5'b00001,
               S1   = 5'b00010,
               S2   = 5'b00100,
               S3   = 5'b01000,
               S4   = 5'b10000;

    reg [4:0] state, next_state;

    // Next-state logic (combinational)
    always @(*) begin
        // Default to IDLE for safety
        next_state = IDLE;

        case (1'b1) // synthesis parallel_case
            state[0]: // IDLE
                next_state = data_in ? S1 : IDLE;
            state[1]: // S1
                next_state = (data_in == 1'b0) ? S2 : S1;
            state[2]: // S2
                next_state = (data_in == 1'b0) ? S3 : S1;
            state[3]: // S3
                next_state = data_in ? S4 : IDLE;
            state[4]: // S4
                next_state = data_in ? S1 : IDLE;
            default:
                next_state = IDLE;
        endcase
    end

    // State register and output logic
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Moore output: assert when state is S4
            sequence_detected <= (next_state == S4);
        end
    end

endmodule