module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // FSM states
    localparam IDLE = 1'b0, COLLECT = 1'b1;

    reg state;
    reg [1:0] byte_count; // Counts from 0 to 2 (3 bytes total)
    reg [7:0] byte0, byte1, byte2;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 0;
            done <= 0;
            out_bytes <= 24'b0;
            byte0 <= 8'b0;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
        end else begin
            done <= 0; // default no done

            case(state)
                IDLE: begin
                    if (in[3]) begin
                        // Start collecting message
                        byte0 <= in;
                        byte_count <= 1;
                        state <= COLLECT;
                    end
                end

                COLLECT: begin
                    case(byte_count)
                        1: begin
                            byte1 <= in;
                            byte_count <= 2;
                        end
                        2: begin
                            byte2 <= in;
                            byte_count <= 3;
                        end
                        3: begin
                            // Should not happen, but safe fallback
                            state <= IDLE;
                            byte_count <= 0;
                        end
                    endcase

                    if (byte_count == 3) begin
                        // Wait for done cycle next clock (not required per problem)
                        // But here we signal done immediately after 3rd byte
                    end

                    // On the cycle after storing third byte, signal done
                    if (byte_count == 3) begin
                        out_bytes <= {byte0, byte1, byte2};
                        done <= 1;
                        state <= IDLE;
                        byte_count <= 0;
                    end
                end
            endcase
        end
    end

endmodule