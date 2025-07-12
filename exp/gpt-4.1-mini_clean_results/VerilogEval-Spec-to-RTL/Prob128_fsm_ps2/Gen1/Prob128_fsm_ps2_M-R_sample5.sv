module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    localparam WAIT_FOR_START = 1'b0;
    localparam COUNT_BYTES    = 1'b1;

    reg state, next_state;
    reg [1:0] byte_count;  // counts 0 to 3

    // Sequential logic: state and byte count update
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            byte_count <= 2'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // done defaults to 0; set below when needed
            done <= 1'b0;

            case (state)
                WAIT_FOR_START: begin
                    if (in[3]) begin
                        byte_count <= 2'd1; // first byte detected
                    end else begin
                        byte_count <= 2'd0;
                    end
                end

                COUNT_BYTES: begin
                    byte_count <= byte_count + 2'd1;
                    if (byte_count == 2'd3) begin
                        done <= 1'b1;  // done asserted right after third byte
                        byte_count <= 2'd0;
                    end
                end

                default: begin
                    byte_count <= 2'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WAIT_FOR_START: begin
                if (in[3])
                    next_state = COUNT_BYTES;
                else
                    next_state = WAIT_FOR_START;
            end

            COUNT_BYTES: begin
                if (byte_count == 2'd3)
                    next_state = WAIT_FOR_START;
                else
                    next_state = COUNT_BYTES;
            end

            default: next_state = WAIT_FOR_START;
        endcase
    end

endmodule