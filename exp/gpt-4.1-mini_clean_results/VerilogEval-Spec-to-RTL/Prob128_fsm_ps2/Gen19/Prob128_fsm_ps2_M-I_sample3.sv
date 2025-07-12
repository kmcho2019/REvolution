module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] count;
    wire count_enable;
    wire done_pulse;

    // Enable counting only when inside a message or when detecting start byte
    assign count_enable = (count != 2'd0) || in[3];
    // done is asserted when count is 2 (third byte received)
    assign done_pulse = (count == 2'd2);

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done <= 1'b0;
        end else begin
            done <= done_pulse;
            if (count_enable) begin
                if (done_pulse)
                    count <= 2'd0; // message complete, reset count
                else if (count == 2'd0)
                    count <= 2'd1; // first byte detected
                else
                    count <= count + 1'b1; // increment within message
            end else begin
                count <= 2'd0; // outside message, hold count at 0
            end
        end
    end

endmodule