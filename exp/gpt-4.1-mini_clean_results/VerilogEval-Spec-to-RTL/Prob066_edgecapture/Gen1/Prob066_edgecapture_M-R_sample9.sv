module TopModule (
    input              clk,
    input              reset,
    input      [31:0]  in,
    output reg [31:0]  out
);

    reg [31:0] prev_in;

    // Register previous input for edge detection
    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
        end else begin
            prev_in <= in;
        end
    end

    // Capture 1->0 transitions and hold them until reset
    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
        end else begin
            out <= out | (prev_in & ~in);
        end
    end

endmodule