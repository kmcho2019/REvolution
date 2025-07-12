module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] count;
    reg done_next;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done <= 1'b0;
        end else begin
            done <= done_next;
            done_next <= 1'b0;
            if (count == 2'd0) begin
                if (in[3]) 
                    count <= 2'd1;
                // else no change, avoid toggling count unnecessarily
            end else begin
                count <= count + 1'b1;
                if (count == 2'd2) begin
                    // signal done in next cycle, so set done_next here
                    done_next <= 1'b1;
                    count <= 2'd0;
                end
            end
        end
    end

endmodule