module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Combined state and counter (0-10: 0=idle, 1=start, 2-9=data, 10=stop)
    reg [3:0] counter;
    reg [7:0] data_reg;
    reg done_pulse;
    reg waiting;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'd0;
            data_reg <= 8'b0;
            done_pulse <= 1'b0;
            waiting <= 1'b0;
        end else begin
            done_pulse <= 1'b0; // Default no pulse
            
            if (waiting) begin
                if (in) begin // Found stop bit
                    waiting <= 1'b0;
                    counter <= 4'd0;
                end
            end else begin
                case (counter)
                    4'd0: begin // Idle
                        if (~in) counter <= 4'd1; // Start bit detected
                    end
                    
                    4'd1: begin // Start bit
                        if (in) begin // Early stop (invalid)
                            waiting <= 1'b1;
                        end else begin
                            counter <= counter + 1;
                            data_reg[0] <= in; // First data bit
                        end
                    end
                    
                    4'd2,4'd3,4'd4,4'd5,4'd6,4'd7,4'd8: begin // Data bits 1-7
                        if (in & (counter != 4'd9)) begin // Early stop detection
                            waiting <= 1'b1;
                        end else begin
                            counter <= counter + 1;
                            data_reg[counter-1] <= in; // Parallel capture
                        end
                    end
                    
                    4'd9: begin // Last data bit (bit 7)
                        counter <= counter + 1;
                        data_reg[7] <= in;
                    end
                    
                    4'd10: begin // Stop bit
                        if (in) begin // Valid stop
                            done_pulse <= 1'b1;
                            counter <= 4'd0;
                        end else begin
                            waiting <= 1'b1;
                        end
                    end
                endcase
            end
        end
    end

    assign done = done_pulse;

endmodule