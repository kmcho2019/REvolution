module TopModule (
    input        clk,
    input        rst_n,  // Asynchronous active-low reset
    input        en,     // Enable signal for loading data
    input  [7:0] d,
    output [7:0] q
);
    reg [7:0] q_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q_reg <= 8'b0;
        else if (en)
            q_reg <= d;
    end

    assign q = q_reg;

endmodule