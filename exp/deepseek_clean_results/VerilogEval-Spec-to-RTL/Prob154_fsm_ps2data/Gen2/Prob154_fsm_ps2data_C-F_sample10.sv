module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_counter;

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            case (byte_counter)
                2'b00: begin // IDLE state
                    if (in[3]) begin
                        out_bytes[23:16] <= in;
                        byte_counter <= 2'b01;
                    end
                end
                
                2'b01: begin // First byte received
                    out_bytes[15:8] <= in;
                    byte_counter <= 2'b10;
                end
                
                2'b10: begin // Second byte received
                    out_bytes[7:0] <= in;
                    done <= 1'b1;
                    byte_counter <= 2'b00;
                end
                
                default: begin
                    byte_counter <= 2'b00;
                end
            endcase
        end
    end

endmodule