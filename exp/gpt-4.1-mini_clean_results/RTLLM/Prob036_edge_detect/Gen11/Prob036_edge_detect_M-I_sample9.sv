module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_reg;

    // Register input 'a' to synchronize and detect edges
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_reg <= 1'b0;
        else
            a_reg <= a;
    end

    // Register rise and down outputs to be high for one cycle after edge detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (~a_reg) & a;  // Rising edge detected
            down <= a_reg & (~a);  // Falling edge detected
        end
    end

endmodule