module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] count; // counts bytes received: 0 = searching, 1..3 = bytes in message

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'b00;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default no done
            if (count == 2'd3) begin
                done <= 1'b1; // done after 3rd byte
                count <= 2'd0; // reset to searching
            end else if (count == 2'd0) begin
                if (in[3] == 1'b1)
                    count <= 2'd1; // start of message
            end else begin
                count <= count + 1'b1; // count next bytes
            end
        end
    end

endmodule