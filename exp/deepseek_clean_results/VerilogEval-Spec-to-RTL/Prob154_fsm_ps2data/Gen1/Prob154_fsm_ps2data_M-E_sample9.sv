module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_counter;
    reg [7:0] byte1, byte2, byte3;

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b0;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            done <= 1'b0;
            out_bytes <= 24'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            // Byte counter logic
            case (byte_counter)
                2'b00: begin
                    if (in[3]) begin
                        byte1 <= in;
                        byte_counter <= 2'b01;
                    end
                end
                2'b01: begin
                    byte2 <= in;
                    byte_counter <= 2'b10;
                end
                2'b10: begin
                    byte3 <= in;
                    byte_counter <= 2'b11;
                end
                2'b11: begin
                    // Output the complete message
                    out_bytes <= {byte1, byte2, byte3};
                    done <= 1'b1;
                    
                    // Check if next byte starts new message
                    if (in[3]) begin
                        byte1 <= in;
                        byte_counter <= 2'b01;
                    end else begin
                        byte_counter <= 2'b00;
                    end
                end
            endcase
        end
    end

endmodule