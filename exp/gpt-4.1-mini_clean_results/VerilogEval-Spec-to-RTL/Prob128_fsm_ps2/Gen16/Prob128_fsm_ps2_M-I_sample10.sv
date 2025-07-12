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
            done <= 1'b0;
        end else begin
            done <= done_d;
            done_d <= 1'b0; // default no done next cycle

            if (count == 2'd0) begin
                if (in[3]) begin
                    count <= 2'd1;
                end
            end else begin
                if (count == 2'd2) begin
                    done_d <= 1'b1; // signal done next cycle
                    count <= 2'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule