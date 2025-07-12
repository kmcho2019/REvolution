module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [2:0] seq_tracker;  // Tracks message progress: [2]=done, [1]=byte2, [0]=byte1

    always @(posedge clk) begin
        if (reset) begin
            seq_tracker <= 3'b000;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            // Check for message boundary violations
            if ((seq_tracker[0] && in[3]) ||   // Byte1 received and new start detected
                (seq_tracker[1] && in[3])) begin  // Byte2 received and new start detected
                seq_tracker <= {2'b00, in[3]};  // Reset with potential new start
            end
            else begin
                // Normal progression
                case (seq_tracker)
                    3'b000: if (in[3]) seq_tracker <= 3'b001;  // Start new message
                    3'b001: seq_tracker <= 3'b011;             // Received byte 2
                    3'b011: begin
                        seq_tracker <= 3'b000;                 // Reset after full message
                        done <= 1'b1;                          // Signal completion
                    end
                    default: seq_tracker <= 3'b000;             // Error recovery
                endcase
            end
        end
    end

endmodule