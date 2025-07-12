module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_count;
    reg collecting;
    reg [23:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'b00;
            collecting <= 1'b0;
            done <= 1'b0;
            shift_reg <= 24'bx;
            out_bytes <= 24'bx;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            if (collecting) begin
                // Shift in new byte
                shift_reg <= {shift_reg[15:0], in};
                byte_count <= byte_count + 1;
                
                // Check if we've collected all 3 bytes
                if (byte_count == 2'b10) begin
                    out_bytes <= {shift_reg[15:0], in};
                    done <= 1'b1;
                    collecting <= 1'b0;
                end
            end else begin
                // Look for start of message
                if (in[3]) begin
                    collecting <= 1'b1;
                    byte_count <= 2'b00;
                    shift_reg <= {16'b0, in};
                end
            end
        end
    end

endmodule