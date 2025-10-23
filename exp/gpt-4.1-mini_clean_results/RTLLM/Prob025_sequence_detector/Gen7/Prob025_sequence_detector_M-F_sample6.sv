module sequence_detector (
    input  wire clk,
    input  wire rst_n,       // active low synchronous reset (renamed to match testbench)
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE = 3'd0,   // no match yet
        S1   = 3'd1,   // matched '1'
        S2   = 3'd2,   // matched '10'
        S3   = 3'd3,   // matched '100'
        S4   = 3'd4    // matched '1001' (final detection state)
    } state_t;

    state_t state, next_state;

    // Next state combinational logic (Moore FSM)
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                if (~data_in)
                    next_state = S2;
                else
                    next_state = S1;
            end

            S2: begin
                if (~data_in)
                    next_state = S3;
                else
                    next_state = S1;
            end

            S3: begin
                if (data_in)
                    next_state = S4;
                else
                    next_state = IDLE;
            end

            S4: begin
                // After detection, restart detection with overlap:
                // since last bit is '1', can start again from S1 or IDLE depending on input
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Output asserted only in final state S4 (Moore output)
            sequence_detected <= (next_state == S4);
        end
    end

endmodule