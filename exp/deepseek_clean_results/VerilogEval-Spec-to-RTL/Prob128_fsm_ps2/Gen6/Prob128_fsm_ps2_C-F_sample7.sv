module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            // State transition logic
            case (cnt)
                2'b00: begin
                    if (in[3]) begin
                        cnt <= 2'b01;  // Start new message
                    end
                end
                2'b01: cnt <= 2'b10;   // Second byte
                2'b10: begin
                    cnt <= 2'b00;      // Reset after third byte
                    done <= 1'b1;      // Assert done
                end
                default: cnt <= 2'b00; // Handle unexpected states
            endcase
        end
    end

endmodule