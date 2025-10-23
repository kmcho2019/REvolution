module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [7:0] fifo[2:0];
reg [1:0] fifo_ptr;
reg [1:0] packet_ptr;
reg [23:0] packet;

always @(posedge clk) begin
    if (reset) begin
        fifo_ptr <= 0;
        packet_ptr <= 0;
        packet <= 0;
        out_bytes <= 0;
        done <= 0;
    end else begin
        // Boundary Detection
        if (in[3]) begin
            fifo[fifo_ptr] <= in;
            fifo_ptr <= fifo_ptr + 1;
        end
        
        // Byte Capture
        if (fifo_ptr > 0) begin
            packet[23:16] <= fifo[0];
            packet[15:8] <= fifo[1];
            packet[7:0] <= in;
            packet_ptr <= packet_ptr + 1;
        end
        
        // Packet Assembly
        if (packet_ptr == 2) begin
            out_bytes <= packet;
            done <= 1;
            packet_ptr <= 0;
            fifo_ptr <= 0;
        end else begin
            done <= 0;
        end
    end
end

endmodule