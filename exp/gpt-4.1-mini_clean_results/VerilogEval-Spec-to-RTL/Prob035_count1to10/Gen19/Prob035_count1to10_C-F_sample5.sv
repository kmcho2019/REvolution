module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] count;

    always @(posedge clk) begin
        if (reset)
            count <= 4'd0;  // internal count 0 represents output 1
        else if (count == 4'd9)
            count <= 4'd0;
        else
            count <= count + 1'b1;
    end

    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;
        else
            q <= count + 1'b1;
    end

endmodule