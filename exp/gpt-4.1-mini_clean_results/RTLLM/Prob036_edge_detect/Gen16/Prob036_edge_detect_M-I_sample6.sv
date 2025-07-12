module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    reg a_reg;

    // Clock enable: update a_reg only when 'a' changes
    wire a_change = (a_reg != a);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_reg <= 1'b0;
        else if (a_change)
            a_reg <= a;
    end

    assign rise = (~a_reg) & a;  // rising edge detected
    assign down = a_reg & (~a);  // falling edge detected

endmodule