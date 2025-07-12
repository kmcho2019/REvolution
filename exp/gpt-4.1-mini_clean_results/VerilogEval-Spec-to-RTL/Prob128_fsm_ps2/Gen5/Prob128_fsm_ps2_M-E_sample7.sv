module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] byte_count; // counts from 0 to 3 for bytes received in current message

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default no done

            case (byte_count)
                2'd0: begin
                    // Waiting for first byte of message: in[3] must be 1
                    if (in[3]) begin
                        byte_count <= 2'd1;
                    end else begin
                        byte_count <= 2'd0; // keep waiting
                    end
                end

                2'd1: begin
                    // Second byte in message, accept any byte
                    byte_count <= 2'd2;
                end

                2'd2: begin
                    // Third byte in message received
                    byte_count <= 2'd0; // reset to wait next message
                    done <= 1'b1;       // done pulse signaling message complete
                end

                default: byte_count <= 2'd0;
            endcase
        end
    end

endmodule