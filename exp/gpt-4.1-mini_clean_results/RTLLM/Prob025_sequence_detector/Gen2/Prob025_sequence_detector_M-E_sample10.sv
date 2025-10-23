module sequence_detector(
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding: binary
    // States represent how many bits matched so far of "1001"
    typedef enum reg [2:0] {
        IDLE = 3'b000,  // No match yet
        S1   = 3'b001,  // matched '1'
        S2   = 3'b010,  // matched '10'
        S3   = 3'b011   // matched '100'
    } state_t;

    reg [2:0] current_state, next_state;

    always @(*) begin
        sequence_detected = 1'b0; // default

        case (current_state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                if (data_in == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;
            end

            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    next_state = S1;
            end

            S3: begin
                if (data_in == 1'b1) begin
                    next_state = S1;
                    sequence_detected = 1'b1; // sequence "1001" detected
                end else begin
                    next_state = IDLE;
                end
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

endmodule