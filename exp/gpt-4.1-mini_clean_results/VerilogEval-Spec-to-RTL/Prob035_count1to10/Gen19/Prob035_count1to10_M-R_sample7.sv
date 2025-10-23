module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

    reg [3:0] count;

    // Sequential logic: binary counter from 1 to 10 with synchronous reset
    always @(posedge clk) begin
        if (reset)
            count <= 4'd1;
        else if (count == 4'd10)
            count <= 4'd1;
        else
            count <= count + 4'd1;
    end

    // Output directly driven by counter
    assign q = count;

endmodule