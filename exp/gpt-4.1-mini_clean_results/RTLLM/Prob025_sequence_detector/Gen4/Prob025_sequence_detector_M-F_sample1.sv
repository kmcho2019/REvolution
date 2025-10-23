module sequence_detector (
    input  wire clk,
    input  wire rst_n,           // Active low reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding using typedef enum for clarity and synthesis friendliness
    typedef enum reg [2:0] {
        IDLE = 3'b000,
        S1   = 3'b001,
        S2   = 3'b010,
        S3   = 3'b011,
        S4   = 3'b100
    } state_t;

    state_t state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: 
                next_state = (data_in == 1'b1) ? S1 : IDLE;

            S1:
                next_state = (data_in == 1'b0) ? S2 : S1;

            S2:
                next_state = (data_in == 1'b0) ? IDLE : S3;

            S3:
                next_state = (data_in == 1'b1) ? S4 : S1;

            S4:
                // After detection, check for overlapping sequence start
                next_state = (data_in == 1'b1) ? S1 : S2;

            default:
                next_state = IDLE;
        endcase
    end

    // Sequential state and output logic with synchronous active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            sequence_detected <= (next_state == S4);
        end
    end

endmodule