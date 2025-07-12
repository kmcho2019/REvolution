module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_dly;

    // Register input 'a' to create a delayed version for edge detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_dly <= 1'b0;
        else
            a_dly <= a;
    end

    // Generate edge detection output signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (~a_dly & a) ? 1'b1 : 1'b0;
            down <= (a_dly & ~a) ? 1'b1 : 1'b0;
        end
    end

endmodule