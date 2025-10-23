module TopModule (
    input clk,
    input a,
    output reg q
);

    always @(posedge clk) begin
        if (q === 1'bx)    // Initialize q at first clock to 0
            q <= 1'b0;
        else
            q <= (~a) & q;
    end

endmodule