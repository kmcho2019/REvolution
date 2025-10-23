module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [3:0] counter;  // Combines state and bit count [3:1] = bit count, [0] = phase
    reg [7:0] shift_reg;
    wire receiving = (counter[3:1] != 3'b000);  // Any non-zero count means we're receiving
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
            shift_reg <= 8'b0;
        end else begin
            done <= 1'b0;
            
            casez (counter)
                4'b0000: begin  // Idle state
                    if (~in) begin  // Start bit detected
                        counter <= 4'b0001;
                        shift_reg <= 8'b0;
                    end
                end
                
                4'b1???: begin  // Stop bit check (counter[3] set)
                    if (in) begin  // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        counter <= 4'b0000;
                    end else begin  // Invalid stop bit
                        counter <= 4'b1000;  // Wait for next 1
                    end
                end
                
                default: begin  // Receiving data bits
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first
                    
                    if (counter[3:1] == 3'b111) begin
                        counter <= 4'b1000;  // Next is stop bit
                    end else begin
                        counter <= counter + 1;
                    end
                end
            endcase
        end
    end

endmodule