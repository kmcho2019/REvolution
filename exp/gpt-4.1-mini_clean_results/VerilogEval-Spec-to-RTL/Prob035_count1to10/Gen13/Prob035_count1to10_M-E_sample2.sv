module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] count;  // internal count: 0 to 9 representing output q=1 to 10

    always @(posedge clk) begin
        if (reset)
            count <= 4'd0; // corresponds to q=1
        else if (count == 4'd9)
            count <= 4'd0; // wrap around after 9 (decimal 10)
        else
            count <= count + 1'b1;
    end

    always @(*) begin
        q = count + 4'd1; // output is count plus one
    end

endmodule