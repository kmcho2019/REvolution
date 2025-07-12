module TopModule (
    input        clk,
    input        reset,
    output reg [3:0] q
);

    reg [3:0] count;

    // Internal count from 0 to 9; output q = count + 1
    always @(posedge clk) begin
        if (reset)
            count <= 4'd0;
        else if (count == 4'd9)
            count <= 4'd0;
        else
            count <= count + 4'd1;
    end

    always @(*) begin
        q = count + 4'd1;
    end

endmodule