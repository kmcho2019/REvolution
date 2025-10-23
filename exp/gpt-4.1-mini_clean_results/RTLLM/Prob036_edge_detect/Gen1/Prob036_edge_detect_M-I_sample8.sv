module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d;

    // Register input 'a' with synchronous reset
    always @(posedge clk) begin
        if (!rst_n)
            a_d <= 1'b0;
        else
            a_d <= a;
    end

    // Detect edges based on registered value of 'a' and previous value 'a_d'
    // Outputs are set high for one clock cycle immediately after the edge is detected
    always @(posedge clk) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (~a_d) & a;
            down <= a_d & (~a);
        end
    end

endmodule