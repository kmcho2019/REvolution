module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q
);
    // Clock enable active when reset asserted or input differs from current q
    wire clk_en = r | (d ^ q);

    always @(posedge clk) begin
        if (clk_en) begin
            if (r)
                q <= 1'b0;
            else
                q <= d;
        end
    end

endmodule