module sequence_detector (
    input  wire clk,
    input  wire reset_n,      // Active-low asynchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot state encoding for clarity and quick decoding
    localparam IDLE = 5'b00001;
    localparam S1   = 5'b00010; // matched '1'
    localparam S2   = 5'b00100; // matched '10'
    localparam S3   = 5'b01000; // matched '100'
    localparam S4   = 5'b10000; // matched '1001'

    reg [4:0] state, next_state;

    // Combinational next-state logic
    always @(*) begin
        case (state)
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
                    next_state = S1; // still matched '1' for overlapping detection
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    next_state = IDLE;
            end
            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;
                else
                    next_state = S2; // '10' matched again for overlap
            end
            S4: begin
                // Sequence detected; next transition based on input for overlap
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = S2;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // sequence_detected is high only when fully matched state reached
            sequence_detected <= (next_state == S4);
        end
    end

endmodule