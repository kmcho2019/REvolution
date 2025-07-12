module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [3:0] counter;
    reg [7:0] data_buffer;
    wire is_receiving = (counter >= 1) && (counter <= 8);
    wire is_stop_check = (counter == 9);
    wire is_error = (counter >= 10);

    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'b0;
            data_buffer <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // Default to not done
            
            case (counter)
                0: begin  // IDLE
                    if (in == 1'b0) begin
                        counter <= 1;  // Start bit detected
                        data_buffer <= 8'b0;
                    end
                end
                
                1,2,3,4,5,6,7,8: begin  // Data bits
                    data_buffer <= {in, data_buffer[7:1]};  // Shift right
                    counter <= counter + 1;
                    
                    // Early stop bit detection (if line goes high early)
                    if (in && (counter > 4)) begin
                        counter <= 9;  // Jump to stop check
                    end
                end
                
                9: begin  // Stop bit check
                    if (in) begin
                        out_byte <= data_buffer;
                        done <= 1'b1;
                        counter <= 0;  // Return to IDLE
                    end else begin
                        counter <= 10;  // Enter error recovery
                    end
                end
                
                default: begin  // Error recovery (10-15)
                    if (in) begin
                        counter <= 0;  // Valid stop bit found
                    end else if (counter < 15) begin
                        counter <= counter + 1;
                    end
                end
            endcase
        end
    end

endmodule