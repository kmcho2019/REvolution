module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_dly;

    // Register the previous value of 'a' to detect edges
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_dly <= 1'b0;
        else
            a_dly <= a;
    end

    // Combinational signals for edge detection
    wire rising_edge  = (~a_dly) & a;
    wire falling_edge = a_dly & (~a);

    // Register output pulses for rising and falling edges, one clock cycle duration
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= rising_edge;
            down <= falling_edge;
        end
    end

endmodule