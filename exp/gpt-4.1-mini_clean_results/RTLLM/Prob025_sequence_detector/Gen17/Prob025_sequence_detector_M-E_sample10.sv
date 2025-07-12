module sequence_detector (
    input  wire clk,
    input  wire reset,          // Active-high synchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // State encoding (2 bits)
    localparam IDLE = 2'b00,    // No match yet
               S1   = 2'b01,    // Matched '1'
               S2   = 2'b10,    // Matched '10'
               S3   = 2'b11;    // Matched '100'

    reg [1:0] state, next_state;
    reg detected;

    // Sequential logic: update state and detected on clock edge
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            detected <= 1'b0;
        end else begin
            state <= next_state;
            detected <= 1'b0; // Default low; set high in next_state logic when detected
        end
    end

    // Next state logic and output detection (Mealy machine)
    always @(*) begin
        next_state = IDLE;
        // Default no detection
        // Default detected already set low in sequential block, but to keep Mealy output style,
        // we must handle it here combinationally and sync it after clock edge

        case(state)
            IDLE: begin
                if (data_in)      // input bit '1'
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                if (!data_in)     // input bit '0'
                    next_state = S2;
                else              // input bit '1'
                    next_state = S1;
            end
            S2: begin
                if (!data_in)     // input bit '0'
                    next_state = S3;
                else              // input bit '1'
                    next_state = S1;
            end
            S3: begin
                if (data_in) begin // input bit '1' completes the sequence "1001"
                    next_state = S1;
                    // detected will be asserted next cycle by detected flag set below
                end else begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Since output is Mealy style, update detected combinationally on clock edge with input and state
    always @(*) begin
        detected = 1'b0;
        if (state == S3 && data_in)
            detected = 1'b1;
    end

    assign sequence_detected = detected;

endmodule