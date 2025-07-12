module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [23:0] message_shift_reg;
    reg [1:0] byte_count;
    reg state;

    localparam SEARCH = 1'b0;
    localparam COLLECT = 1'b1;

    always @(posedge clk) begin
        if (reset) begin
            message_shift_reg <= 24'b0;
            byte_count <= 2'b0;
            state <= SEARCH;
            done <= 1'b0;
        end else begin
            case (state)
                SEARCH: begin
                    if (in[3]) begin
                        // Found start of message
                        message_shift_reg <= {message_shift_reg[15:0], in};
                        byte_count <= 2'b1;
                        state <= COLLECT;
                        done <= 1'b0;
                    end else begin
                        // Keep searching
                        done <= 1'b0;
                    end
                end
                COLLECT: begin
                    message_shift_reg <= {message_shift_reg[15:0], in};
                    if (byte_count == 2'b10) begin
                        // Complete message received
                        byte_count <= 2'b0;
                        state <= SEARCH;
                        done <= 1'b1;
                    end else begin
                        // Continue collecting
                        byte_count <= byte_count + 1'b1;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule