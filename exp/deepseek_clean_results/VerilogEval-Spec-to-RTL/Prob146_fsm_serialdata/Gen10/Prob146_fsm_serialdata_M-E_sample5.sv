module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Circular buffer for received bits
    reg [9:0] bit_buffer;  // Stores up to 10 bits (start + 8 data + stop)
    reg [3:0] counter;     // Tracks both state and bit position
    
    // Counter values encode state:
    // 0-9: Receiving bits (0=start, 1-8=data, 9=stop)
    // 10: Idle state
    // 11: Error recovery
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 10;  // Start in idle
            bit_buffer <= 10'b1111111111;  // Initialize to idle state
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // Default assignment
            
            case (counter)
                // Idle state
                10: begin
                    if (in == 0) begin
                        counter <= 0;
                        bit_buffer <= {9'b111111111, in};  // Store start bit
                    end
                end
                
                // Receiving bits (0-8)
                0,1,2,3,4,5,6,7,8: begin
                    bit_buffer <= {bit_buffer[8:0], in};
                    counter <= counter + 1;
                end
                
                // Stop bit check
                9: begin
                    if (in) begin  // Valid stop bit
                        out_byte <= bit_buffer[7:0];  // Extract data bits
                        done <= 1'b1;
                        counter <= 10;  // Return to idle
                    end else begin
                        counter <= 11;  // Error recovery
                    end
                end
                
                // Error recovery - wait for stop bit
                11: begin
                    if (in) begin
                        counter <= 10;  // Return to idle
                    end
                end
                
                default: counter <= 10;
            endcase
        end
    end

endmodule