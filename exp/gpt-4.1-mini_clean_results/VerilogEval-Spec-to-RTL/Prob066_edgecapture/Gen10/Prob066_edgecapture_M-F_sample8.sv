module TopModule (
    input              clk,
    input              reset,
    input      [31:0]  in,
    output     [31:0]  out
);

    reg [31:0] prev_in;
    reg [31:0] capture;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= in;        // Initialize prev_in with current input on reset
            capture <= 32'b0;
        end else begin
            capture <= capture | (prev_in & ~in);
            prev_in <= in;
        end
    end

    assign out = capture;

endmodule