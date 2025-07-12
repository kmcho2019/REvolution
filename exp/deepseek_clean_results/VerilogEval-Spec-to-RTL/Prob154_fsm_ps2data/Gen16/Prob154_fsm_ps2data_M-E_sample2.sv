module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_count;
    reg capturing;

    always @(posedge clk) begin
        if (reset) begin
            out_bytes <= 24'bx;
            done <= 1'b0;
            byte_count <= 2'b0;
            capturing <= 1'b0;
        end else begin
            done <= 1'b0;
            
            if (in[3] && !capturing) begin
                // Start new message
                out_bytes <= {in, 16'bx};
                byte_count <= 2'b01;
                capturing <= 1'b1;
            end else if (capturing) begin
                // Shift in next byte
                out_bytes <= {out_bytes[15:0], in};
                byte_count <= byte_count + 1'b1;
                
                if (byte_count == 2'b10) begin
                    // Third byte received
                    done <= 1'b1;
                    capturing <= 1'b0;
                end
            end
        end
    end

endmodule