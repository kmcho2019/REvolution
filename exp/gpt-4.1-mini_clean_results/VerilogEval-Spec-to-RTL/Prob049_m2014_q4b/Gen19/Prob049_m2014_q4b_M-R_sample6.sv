module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

    // Asynchronous reset process
    always @(posedge clk) begin
        if (!ar) // if reset is inactive
            q <= d;
    end

    always @(posedge ar) begin
        q <= 1'b0; // asynchronous reset assertion immediately clears q
    end

endmodule