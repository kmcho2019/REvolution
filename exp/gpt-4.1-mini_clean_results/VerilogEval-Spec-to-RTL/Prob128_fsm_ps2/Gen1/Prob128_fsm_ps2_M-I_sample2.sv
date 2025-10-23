module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] byte_count; // 0 = waiting for start byte; 1 and 2 for subsequent bytes

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'd0;
            done       <= 1'b0;
        end else begin
            done <= 1'b0; // Default done is 0 every cycle

            case (byte_count)
                2'd0: begin
                    // Waiting for start of message (byte with in[3] == 1)
                    if (in[3] == 1'b1) 
                        byte_count <= 2'd1;
                end
                2'd1: begin
                    // Received first byte, expecting second byte now unconditionally
                    byte_count <= 2'd2;
                end
                2'd2: begin
                    // Received second byte, next is third byte
                    byte_count <= 2'd3;
                end
                2'd3: begin
                    // Third byte received, signal done and reset count
                    done <= 1'b1;
                    byte_count <= 2'd0;
                end
                default: byte_count <= 2'd0;
            endcase
        end
    end

endmodule