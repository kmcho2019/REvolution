module sequence_detector (
    input  wire clk,
    input  wire reset_n,        // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (2 bits for 4 states)
    localparam IDLE = 2'b00,
               S1   = 2'b01,
               S2   = 2'b10,
               S3   = 2'b11;

    reg [1:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic and combinational output
    always @(*) begin
        sequence_detected = 1'b0;  // Default output
        case(state)
            IDLE: begin
                next_state = data_in ? S1 : IDLE;
            end
            S1: begin
                next_state = data_in ? S1 : S2;
            end
            S2: begin
                next_state = data_in ? S1 : S3;
            end
            S3: begin
                if (data_in) begin
                    next_state = S1;
                    sequence_detected = 1'b1;  // "1001" sequence detected
                end else begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule