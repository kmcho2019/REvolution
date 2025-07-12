module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_counter;
    reg collecting;

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b00;
            collecting <= 1'b0;
            out_bytes <= 24'bx;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            
            if (collecting) begin
                // Shift in new byte and increment counter
                out_bytes <= {out_bytes[15:0], in};
                byte_counter <= byte_counter + 1;
                
                // Check if we've collected all 3 bytes
                if (byte_counter == 2'b10) begin
                    done <= 1'b1;
                    collecting <= 1'b0;
                end
            end else begin
                // Look for start of message (in[3]=1)
                if (in[3]) begin
                    collecting <= 1'b1;
                    byte_counter <= 2'b00;
                    out_bytes <= {16'b0, in};  // Initialize with first byte
                end
            end
        end
    end

endmodule