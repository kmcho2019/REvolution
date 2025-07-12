module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot state encoding: [IDLE, FIRST, SECOND, DONE]
    reg [3:0] state;

    // Clock enable signals
    wire first_byte_en = (state[0] & in[3]) | reset;
    wire second_byte_en = state[1] | reset;
    wire third_byte_en = state[2] | reset;

    always @(posedge clk) begin
        if (reset) begin
            state <= 4'b0001;  // IDLE
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            // State transitions
            case (1'b1)
                state[0]: begin // IDLE
                    if (in[3]) begin
                        state <= 4'b0010; // FIRST
                        out_bytes[23:16] <= in;
                    end
                end
                state[1]: begin // FIRST
                    state <= 4'b0100; // SECOND
                    out_bytes[15:8] <= in;
                end
                state[2]: begin // SECOND
                    state <= 4'b1000; // DONE
                    out_bytes[7:0] <= in;
                    done <= 1'b1;
                end
                state[3]: begin // DONE
                    state <= 4'b0001; // Back to IDLE
                    if (in[3]) begin // Handle back-to-back messages
                        state <= 4'b0010; // FIRST
                        out_bytes[23:16] <= in;
                    end
                end
            endcase
        end
    end

    // Clock gating for out_bytes (conceptual - actual implementation depends on library)
    always @(posedge clk) begin
        if (first_byte_en) out_bytes[23:16] <= reset ? 8'b0 : in;
        if (second_byte_en) out_bytes[15:8] <= reset ? 8'b0 : in;
        if (third_byte_en) out_bytes[7:0] <= reset ? 8'b0 : in;
    end

endmodule