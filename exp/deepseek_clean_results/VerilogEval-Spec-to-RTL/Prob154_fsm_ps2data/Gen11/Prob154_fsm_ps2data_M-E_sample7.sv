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
            out_bytes <= 24'bx;
            byte_counter <= 2'b00;
            collecting <= 1'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            
            if (!collecting && in[3]) begin
                // Start new message collection
                out_bytes <= {in, 16'bx};
                byte_counter <= 2'b01;
                collecting <= 1'b1;
            end else if (collecting) begin
                // Shift in next byte
                out_bytes <= {out_bytes[15:0], in};
                byte_counter <= byte_counter + 1'b1;
                
                if (byte_counter == 2'b10) begin
                    // Third byte received
                    done <= 1'b1;
                    collecting <= 1'b0;
                end
            end
        end
    end

endmodule