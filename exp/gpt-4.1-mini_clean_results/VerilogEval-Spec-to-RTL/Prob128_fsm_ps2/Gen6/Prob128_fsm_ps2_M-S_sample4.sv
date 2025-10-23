module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] count;

    always @(posedge clk) begin
        done <= 0;
        if (reset) begin
            count <= 0;
        end else begin
            if (count == 0) begin
                if (in[3]) count <= 1; // start byte detected
            end else if (count == 3) begin
                done <= 1;
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule