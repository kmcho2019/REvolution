module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] count;

    always @(posedge clk) begin
        if (reset)
            count <= 4'd1;
        else if (count == 4'd10)
            count <= 4'd1;
        else
            count <= count + 1'b1;
    end

    // Register output q to reduce combinational delay and glitches
    always @(posedge clk) begin
        q <= count;
    end

endmodule