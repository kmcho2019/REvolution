module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // Active-low asynchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding as binary
    localparam IDLE = 3'b000;
    localparam S1   = 3'b001;  // matched '1'
    localparam S2   = 3'b010;  // matched '10'
    localparam S3   = 3'b011;  // matched '100'
    localparam S4   = 3'b100;  // matched '1001' (output state)

    reg [2:0] state, next_state;

    // Synchronous state and output update with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Output asserted only in S4 state (Moore output)
            sequence_detected <= (next_state == S4);
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                if (!data_in)
                    next_state = S2;
                else
                    next_state = S1;
            end

            S2: begin
                if (!data_in)
                    next_state = IDLE;
                else
                    next_state = S3;
            end

            S3: begin
                if (data_in)
                    next_state = S4;
                else
                    next_state = S2;
            end

            S4: begin
                // After detection, allow overlap by going to S1 if input is '1', else IDLE
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule