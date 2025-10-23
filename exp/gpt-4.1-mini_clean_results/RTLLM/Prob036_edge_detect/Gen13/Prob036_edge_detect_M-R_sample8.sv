module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 1'b0;
            rise  <= 1'b0;
            down  <= 1'b0;
        end else begin
            // Edge detection
            rise <= (~a_reg) & a;   // Rising edge: a goes from 0 to 1
            down <= a_reg & (~a);   // Falling edge: a goes from 1 to 0
            a_reg <= a;
        end
    end

endmodule