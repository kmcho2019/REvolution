module TopModule (
    input clk,
    input rst_n,   // Active low synchronous reset
    input a,
    output reg [2:0] q
);

    reg a_reg;
    reg [2:0] next_q;

    // Register 'a' to reduce combinational switching and improve timing
    always @(posedge clk) begin
        if (!rst_n)
            a_reg <= 1'b0;
        else
            a_reg <= a;
    end

    // Next state logic computed combinationally based on registered inputs
    always @(*) begin
        if (a_reg)
            next_q = 3'd4;
        else
            next_q = (q == 3'd6) ? 3'd0 : (q + 3'd1);
    end

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (!rst_n)
            q <= 3'd0;
        else
            q <= next_q;
    end

endmodule