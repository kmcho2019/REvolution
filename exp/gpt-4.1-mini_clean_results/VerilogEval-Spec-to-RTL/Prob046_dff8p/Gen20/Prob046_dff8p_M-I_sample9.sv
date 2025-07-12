module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output reg [7:0] q
);

    wire update_en = (d != q);

    always @(negedge clk) begin
        if (reset)
            q <= 8'h34;
        else if (update_en)
            q <= d;
        // else retain q to avoid unnecessary toggling
    end

endmodule