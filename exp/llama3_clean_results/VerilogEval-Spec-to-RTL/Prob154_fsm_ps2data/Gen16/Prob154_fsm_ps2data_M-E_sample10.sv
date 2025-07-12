module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [7:0] byte1, byte2;
reg start_detected, message_received;

always @(posedge clk) begin
    if (reset) begin
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        start_detected <= 1'b0;
        message_received <= 1'b0;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        // Stage 1: Message boundary detection
        if (in[3] == 1'b1 && !start_detected) begin
            byte1 <= in;
            start_detected <= 1'b1;
        end else if (start_detected && !message_received) begin
            // Stage 2: Receive second byte
            byte2 <= in;
            start_detected <= 1'b0;
            message_received <= 1'b1;
        end else begin
            start_detected <= 1'b0;
            message_received <= 1'b0;
        end
        
        // Stage 3: Output message
        if (message_received) begin
            out_bytes <= {byte1, byte2, in};
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end
end

endmodule