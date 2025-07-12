module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_count; // Counts 0-2 for 3-byte message

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'b0;
            out_bytes <= 24'bx;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            
            if (byte_count == 2'b00) begin
                if (in[3]) begin
                    out_bytes[23:16] <= in;
                    byte_count <= 2'b01;
                end
            end else if (byte_count == 2'b01) begin
                out_bytes[15:8] <= in;
                byte_count <= 2'b10;
            end else begin // byte_count == 2'b10
                out_bytes[7:0] <= in;
                done <= 1'b1;
                byte_count <= 2'b00;
            end
        end
    end

endmodule