module TopModule (
    input  clk,
    input  x,
    output z
);
    reg q_xor, q_and, q_or;
    reg [2:0] reset_count = 3'd0;
    wire reset;

    // Generate a synchronous reset signal active during the first 4 clock cycles after power-up
    assign reset = (reset_count != 3'd4);

    always @(posedge clk) begin
        if (reset_count != 3'd4)
            reset_count <= reset_count + 3'd1;
    end

    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    always @(posedge clk) begin
        if (reset) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    assign z = ~(q_xor | q_and | q_or);

endmodule