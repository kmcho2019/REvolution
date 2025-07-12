module TopModule (
    input clk,
    input in,
    output out
);

    reg d_out = 1'b0;  // Initialize to 0
    wire d_input = in ^ d_out;

    always @(posedge clk) begin
        d_out <= d_input;
    end

    assign out = d_out;

endmodule