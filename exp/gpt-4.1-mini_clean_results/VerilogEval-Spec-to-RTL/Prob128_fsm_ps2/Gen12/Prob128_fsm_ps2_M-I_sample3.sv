module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] count;
    wire start_msg = (count == 2'd0) && in[3];
    wire count_enable = (count != 2'd0);
    wire done_next = (count == 2'd2);

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done <= 1'b0;
        end else begin
            done <= done_next;
            if (start_msg)
                count <= 2'd1;
            else if (count_enable)
                count <= count + 1'b1;
            else
                count <= count;
            if (done_next)
                count <= 2'd0;
        end
    end

endmodule