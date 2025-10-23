module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] count; // internal count: 0 to 9

    wire reached_nine = (count == 4'd9);

    always @(posedge clk) begin
        if (reset)
            count <= 4'd0;
        else if (reached_nine)
            count <= 4'd0;
        else
            count <= count + 1'b1;
    end

    always @(*) begin
        q = count + 4'd1; // output is count + 1, so it ranges 1 to 10
    end

endmodule