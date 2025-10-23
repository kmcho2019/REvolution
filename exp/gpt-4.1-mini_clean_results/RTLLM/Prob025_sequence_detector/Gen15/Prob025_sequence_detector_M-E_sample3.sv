module sequence_detector (
    input  wire clk,
    input  wire reset,          // Active high synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (3-bit binary)
    localparam IDLE = 3'd0,
               S1   = 3'd1,  // matched '1'
               S2   = 3'd2,  // matched '10'
               S3   = 3'd3,  // matched '100'
               S4   = 3'd4;  // detected '1001' (transient detection state)

    reg [2:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            sequence_detected <= 1'b0; // default: no detection unless condition met below

            // Mealy output logic: detect sequence on transitions to S4
            // Instead of generating output from state register, use input and current state:
            case(state)
                IDLE: if (data_in == 1'b1)
                          sequence_detected <= 1'b0;
                S1:   if (data_in == 1'b1)
                          sequence_detected <= 1'b0;
                S2:   if (data_in == 1'b1)
                          sequence_detected <= 1'b0;
                S3:   if (data_in == 1'b1)
                          sequence_detected <= 1'b1;  // sequence '1001' detected
                default: sequence_detected <= 1'b0;
            endcase
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
                if (~data_in)
                    next_state = S2;
                else
                    next_state = S1; // still matched '1'
            end
            S2: begin
                if (~data_in)
                    next_state = S3;
                else
                    next_state = S1; // restart matching from '1'
            end
            S3: begin
                if (data_in)
                    next_state = S4; // full sequence detected (transient)
                else
                    next_state = IDLE;
            end
            S4: begin
                // After detection, handle overlapping sequences:
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule