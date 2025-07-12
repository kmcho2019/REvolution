module TopModule (
    input clk,
    input in,
    output out
);

    wire d_input;
    reg q_output = 1'b0;  // Explicit initialization to 0

    assign d_input = in ^ q_output;
    assign out = q_output;

    always @(posedge clk) begin
        q_output <= d_input;
    end

endmodule