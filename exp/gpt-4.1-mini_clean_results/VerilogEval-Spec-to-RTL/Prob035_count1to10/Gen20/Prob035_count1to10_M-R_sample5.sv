module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

    reg [3:0] count;

    // Sequential logic with synchronous reset and counting logic combined
    always @(posedge clk) begin
        if (reset)
            count <= 4'd0;        // Reset count to 0 (outputs 1)
        else if (count == 4'd9)
            count <= 4'd0;        // Wrap from 9 to 0 internally
        else
            count <= count + 1'b1;
    end

    // Output logic: combinationally assign q = count + 1
    assign q = count + 1'b1;

endmodule