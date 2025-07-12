module TopModule(
    input clk,
    input d,
    output reg q
);

    // Update q on both edges directly
    always @(posedge clk or negedge clk) begin
        q <= d;
    end

endmodule