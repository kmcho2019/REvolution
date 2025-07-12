module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done <= 1'b0;
        end else begin
            done <= (count == 2'd3);
            if (count == 2'd0) begin
                // Wait for start byte
                if (in[3])
                    count <= 2'd1;
            end else if (count < 2'd3) begin
                count <= count + 2'd1;
            end else begin
                count <= 2'd0;
            end
        end
    end

endmodule