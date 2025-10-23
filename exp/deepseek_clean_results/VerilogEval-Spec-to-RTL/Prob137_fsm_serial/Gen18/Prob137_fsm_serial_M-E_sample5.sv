module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    reg [3:0] counter;  // Counts 0-9 (0=idle, 1-8=data, 9=stop)
    reg [7:0] data_reg;
    reg data_valid;
    
    // Combinatorial done signal
    assign done = (counter == 4'd9) && in && data_valid;
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'd0;
            data_reg <= 8'b0;
            data_valid <= 1'b0;
        end else begin
            case (counter)
                4'd0: begin // IDLE state
                    if (!in) begin
                        counter <= 4'd1;
                        data_valid <= 1'b0;
                    end
                end
                
                4'd1,4'd2,4'd3,4'd4,4'd5,4'd6,4'd7: begin // DATA bits 1-7
                    counter <= counter + 1;
                end
                
                4'd8: begin // Last data bit (8)
                    data_reg <= {in, data_reg[7:1]}; // Capture all 8 bits
                    counter <= 4'd9;
                    data_valid <= 1'b1;
                end
                
                4'd9: begin // STOP bit
                    if (in) begin
                        counter <= 4'd0; // Valid stop bit, return to IDLE
                    end else begin
                        data_valid <= 1'b0; // Invalid stop bit, wait for next
                    end
                end
                
                default: counter <= 4'd0;
            endcase
        end
    end

endmodule