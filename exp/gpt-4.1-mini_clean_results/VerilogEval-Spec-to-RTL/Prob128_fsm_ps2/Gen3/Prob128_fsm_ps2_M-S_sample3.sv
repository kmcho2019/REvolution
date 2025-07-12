module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] count; // counts 0 to 3

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done <= 1'b0;
        end else begin
            if (count == 2'd0) begin
                if (in[3]) begin
                    count <= 2'd1;
                    done <= 1'b0;
                end else begin
                    done <= 1'b0;
                end
            end else if (count == 2'd3) begin
                done <= 1'b1;
                count <= 2'd0;
            end else begin
                count <= count + 1'b1;
                done <= 1'b0;
            end
        end
    end

endmodule