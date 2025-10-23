module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // Counter serves as both state and bit counter
    // [3:0] counter meaning:
    // 0: IDLE
    // 1-8: Receiving data bits (1=first bit, 8=last bit)
    // 9: Checking stop bit
    // 10: Waiting for stop bit (error recovery)
    reg [3:0] counter;
    reg [7:0] data_reg;
    reg receiving;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'd0;
            data_reg <= 8'b0;
            done <= 1'b0;
            receiving <= 1'b0;
        end else begin
            done <= 1'b0;  // Default to not done
            
            case (counter)
                4'd0: begin  // IDLE
                    if (in == 1'b0) begin
                        counter <= 4'd1;
                        receiving <= 1'b1;
                    end
                end
                
                4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7: begin  // Data bits 1-7
                    data_reg <= {in, data_reg[7:1]};  // LSB first
                    counter <= counter + 1;
                end
                
                4'd8: begin  // Last data bit (bit 8)
                    data_reg <= {in, data_reg[7:1]};
                    counter <= 4'd9;  // Move to stop check
                end
                
                4'd9: begin  // Stop bit check
                    if (in == 1'b1) begin
                        done <= 1'b1;
                        counter <= 4'd0;  // Back to IDLE
                    end else begin
                        counter <= 4'd10;  // Error - wait for stop
                    end
                end
                
                4'd10: begin  // Wait for stop bit
                    if (in == 1'b1) begin
                        counter <= 4'd0;  // Valid stop found
                    end
                end
                
                default: counter <= 4'd0;
            endcase
        end
    end

endmodule