module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

    reg [3:0] count;

    // Sequential logic: synchronous reset and wrap-around counter
    always @(posedge clk) begin
        if (reset)
            count <= 4'd0;       // internal 0 means output 1
        else if (count == 4'd9)
            count <= 4'd0;       // wrap back to 0
        else
            count <= count + 1'b1;
    end

    // Output logic: continuous assignment for output count + 1
    assign q = count + 1'b1;

endmodule