module TopModule (
    input clk,
    input d,
    output reg q
);

    // Update q on both clock edges
    always @(posedge clk) begin
        q <= d;
    end

    always @(negedge clk) begin
        q <= d;
    end

endmodule