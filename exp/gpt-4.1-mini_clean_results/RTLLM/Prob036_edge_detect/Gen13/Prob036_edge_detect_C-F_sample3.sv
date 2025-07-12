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
            // Sample input
            a_reg <= a;

            // Detect edges based on previous sampled 'a_reg' and current 'a'
            rise <= (~a_reg) & a;  // Rising edge: previous low, current high
            down <= a_reg & (~a);  // Falling edge: previous high, current low
        end
    end

endmodule