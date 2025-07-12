module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_dly;
    wire rising_edge;
    wire falling_edge;

    // Store the previous value of 'a' on clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_dly <= 1'b0;
        else
            a_dly <= a;
    end

    // Combinational logic for edge detection
    assign rising_edge  = (~a_dly) & a;
    assign falling_edge = a_dly & (~a);

    // Output registers updated synchronously
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