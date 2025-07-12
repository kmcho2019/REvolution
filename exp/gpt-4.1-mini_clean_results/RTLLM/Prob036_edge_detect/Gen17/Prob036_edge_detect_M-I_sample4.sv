module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_reg;

    // Register input 'a'
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_reg <= 1'b0;
        else
            a_reg <= a;
    end

    wire rise_comb = (~a_reg) & a;  // detect rising edge
    wire down_comb = a_reg & (~a);  // detect falling edge

    // Register rise and down outputs to generate single-cycle pulses
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= rise_comb;
            down <= down_comb;
        end
    end

endmodule