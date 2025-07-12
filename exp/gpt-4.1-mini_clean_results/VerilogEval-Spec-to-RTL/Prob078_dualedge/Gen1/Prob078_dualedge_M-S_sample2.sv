module TopModule(
    input clk,
    input d,
    output reg q
);

    // Update q on rising edge
    always @(posedge clk) begin
        q <= d;
    end

    // Update q on falling edge
    always @(negedge clk) begin
        q <= d;
    end

endmodule