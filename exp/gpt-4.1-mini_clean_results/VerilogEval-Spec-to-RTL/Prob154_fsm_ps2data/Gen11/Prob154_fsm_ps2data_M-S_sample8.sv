module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg        done
);

    // States
    localparam IDLE    = 1'b0;
    localparam READING = 1'b1;

    reg state;
    reg [1:0] byte_count;
    reg [23:0] message;

    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            byte_count <= 2'd0;
            message    <= 24'd0;
            out_bytes  <= 24'd0;
            done       <= 1'b0;
        end else begin
            done <= 1'b0; // default done low

            case (state)
                IDLE: begin
                    byte_count <= 2'd0;
                    if (in[3]) begin
                        message <= {16'd0, in}; // store first byte at least significant byte
                        byte_count <= 2'd1;
                        state <= READING;
                    end
                end

                READING: begin
                    message <= {message[15:0], in}; // shift left by 8 bits and append new byte
                    byte_count <= byte_count + 1'b1;

                    if (byte_count == 2'd2) begin
                        out_bytes <= {message[15:0], in};
                        done <= 1'b1;
                        state <= IDLE;
                        byte_count <= 2'd0;
                    end
                end
            endcase
        end
    end

endmodule