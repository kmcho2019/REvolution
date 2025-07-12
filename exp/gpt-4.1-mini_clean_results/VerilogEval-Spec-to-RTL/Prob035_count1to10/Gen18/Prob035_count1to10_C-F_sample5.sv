module TopModule (
    input        clk,
    input        reset,
    output reg [3:0] q
);

    reg [3:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 4'd0; // internal 0 corresponds to output 1
            q <= 4'd1;
        end else begin
            if (count == 4'd9)
                count <= 4'd0;
            else
                count <= count + 1'b1;

            q <= count + 1'b1;
        end
    end

endmodule