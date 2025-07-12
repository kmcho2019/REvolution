module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);
    always @(posedge clk) begin
        // Only update q when reset is asserted or input d differs from q to reduce switching
        if (r)
            q <= 1'b0;
        else if (d != q)
            q <= d;
    end
endmodule