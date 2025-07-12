module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] count;         // counts bytes: 0=no message, 1=byte1, 2=byte2, 3=byte3 received
    reg [7:0] byte1, byte2, byte3;

    always @(posedge clk) begin
        if (reset) begin
            count     <= 2'd0;
            done      <= 1'b0;
            out_bytes <= 24'b0;
            byte1     <= 8'b0;
            byte2     <= 8'b0;
            byte3     <= 8'b0;
        end else begin
            done <= 1'b0; // default done low each cycle

            if (count == 0) begin
                // Wait for start byte with in[3]==1
                if (in[3]) begin
                    byte1 <= in;
                    count <= 2'd1;
                end
            end else if (count == 1) begin
                byte2 <= in;
                count <= 2'd2;
            end else if (count == 2) begin
                byte3 <= in;
                out_bytes <= {byte1, byte2, in};
                done <= 1'b1;
                count <= 2'd0; // ready for next message
            end
        end
    end

endmodule