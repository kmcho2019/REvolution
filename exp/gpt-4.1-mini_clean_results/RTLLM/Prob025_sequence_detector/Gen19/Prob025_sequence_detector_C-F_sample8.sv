module sequence_detector (
    input  wire clk,
    input  wire rst_n,            // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (3 bits) for 5 states
    localparam IDLE = 3'd0,
               S1   = 3'd1,
               S2   = 3'd2,
               S3   = 3'd3,
               S4   = 3'd4;

    reg [2:0] state, next_state;

    // Combinational logic for next state based on current state and input
    always @(*) begin
        case (state)
            IDLE: 
                // Wait for first '1' to start sequence detection
                next_state = data_in ? S1 : IDLE;

            S1: 
                // After detecting '1', expect '0' to progress, or stay in S1 if another '1' occurs (overlapping)
                next_state = (data_in == 1'b0) ? S2 : S1;

            S2: 
                // After '10', expect '0' to go to S3, else if '1', restart at S1 (possible new sequence start)
                next_state = (data_in == 1'b0) ? S3 : S1;

            S3: 
                // After '100', expect '1' to detect full sequence and go to S4, else reset to IDLE
                next_state = data_in ? S4 : IDLE;

            S4:
                // Sequence detected, output high for one cycle, then restart detection:
                // If input is '1' restart at S1 (overlap), else go to IDLE
                next_state = data_in ? S1 : IDLE;

            default:
                next_state = IDLE;
        endcase
    end

    // Synchronous process: update state and output on clock edge with synchronous reset
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Output asserted for one clock cycle when entering detection state S4
            sequence_detected <= (next_state == S4);
        end
    end

endmodule