module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] count;
    reg done_d;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done_d <= 1'b0;
        end else begin
            done_d <= (count == 2'd2); // done asserted for one cycle after third byte

            if (count == 2'd0) begin
                if (in[3])
                    count <= 2'd1;
            end else if (count == 2'd2) begin
                count <= 2'd0;
            end else begin
                count <= count + 1'b1;
            end
        end
    end

    always @(posedge clk) begin
        done <= done_d;
    end

endmodule