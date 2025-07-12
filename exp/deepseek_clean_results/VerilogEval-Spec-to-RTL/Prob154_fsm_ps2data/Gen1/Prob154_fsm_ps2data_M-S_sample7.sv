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
            done <= 1'b0;
            
            if (byte_counter == 2'b0) begin
                // IDLE state - wait for start byte
                if (in[3]) begin
                    out_bytes[23:16] <= in;
                    byte_counter <= 2'b1;
                end
            end else if (byte_counter == 2'b1) begin
                // First byte received
                out_bytes[15:8] <= in;
                byte_counter <= 2'b10;
            end else begin
                // Second byte received - complete message
                out_bytes[7:0] <= in;
                done <= 1'b1;
                byte_counter <= 2'b0;
            end
        end
    end

endmodule