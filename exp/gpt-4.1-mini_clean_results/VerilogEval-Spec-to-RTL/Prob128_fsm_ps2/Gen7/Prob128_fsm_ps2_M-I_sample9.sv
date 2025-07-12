module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] byte_index;

    always @(posedge clk) begin
        if (reset) begin
            byte_index <= 2'b00;
            done       <= 1'b0;
        end else begin
            done <= 1'b0; // default no done
            case (byte_index)
                2'd0: begin
                    // Waiting for start byte (in[3] == 1)
                    if (in[3]) begin
                        byte_index <= 2'd1;
                    end
                end
                2'd1: begin
                    // Received 1st byte, move to byte 2
                    byte_index <= 2'd2;
                end
                2'd2: begin
                    // Received 2nd byte, move to byte 3
                    byte_index <= 2'd3;
                end
                2'd3: begin
                    // Received 3rd byte, assert done, go back to waiting
                    done       <= 1'b1;
                    byte_index <= 2'd0;
                end
                default: byte_index <= 2'd0;
            endcase
        end
    end

endmodule