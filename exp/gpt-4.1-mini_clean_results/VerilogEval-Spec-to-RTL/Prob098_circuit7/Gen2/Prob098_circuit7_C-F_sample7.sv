module TopModule (
    input clk,
    input a,
    output reg q
);

    always @(posedge clk) begin
        if (q != ~a)  // Update q only if the value changes to reduce unnecessary toggles
            q <= ~a;
    end

endmodule