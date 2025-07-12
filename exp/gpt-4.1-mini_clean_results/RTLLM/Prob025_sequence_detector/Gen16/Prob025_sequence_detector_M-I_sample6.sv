module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // Active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding using 3-bit binary
    localparam IDLE = 3'b000,
               S1   = 3'b001,
               S2   = 3'b010,
               S3   = 3'b011,
               S4   = 3'b100;

    reg [2:0] state, next_state;

    // Next-state logic (combinational)
    always @(*) begin
        case (state)
            IDLE:
                next_state = data_in ? S1 : IDLE;    // Wait for first '1'
            S1:
                next_state = (data_in == 1'b0) ? S2 : S1; // after '1', expect '0'
            S2:
                next_state = (data_in == 1'b0) ? S3 : S1; // after '10', expect '0'
            S3:
                next_state = data_in ? S4 : IDLE;         // after '100', expect '1'
            S4:
                next_state = data_in ? S1 : IDLE;         // detected seq, allow overlapping detection
            default:
                next_state = IDLE;
        endcase
    end

    // State register and output logic
    always @(posedge clk) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Moore output asserted when in S4 state
            sequence_detected <= (next_state == S4);
        end
    end

endmodule