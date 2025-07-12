module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);
    reg a_reg;
    reg [2:0] next_q;
    wire [3:0] incremented = q + 1;  // 4 bits to detect overflow past 6

    // Synchronize input 'a' to clk domain
    always @(posedge clk) begin
        a_reg <= a;
    end

    // Next state logic: if a_reg=1, jump to 4; else increment modulo 7
    always @(*) begin
        if (a_reg)
            next_q = 3'd4;
        else if (incremented == 3'd7)
            next_q = 3'd0;
        else
            next_q = incremented[2:0];
    end

    always @(posedge clk) begin
        q <= next_q;
    end
endmodule