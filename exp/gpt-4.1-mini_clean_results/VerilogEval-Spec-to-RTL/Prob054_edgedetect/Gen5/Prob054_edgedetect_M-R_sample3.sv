module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_d;  // register to hold previous input
    wire [7:0] rising_edge;

    // Store previous input
    always @(posedge clk) begin
        in_d <= in;
    end

    // Detect rising edge combinationally
    assign rising_edge = (~in_d) & in;

    // Register the edge detection output to delay pulse by one cycle
    always @(posedge clk) begin
        pedge <= rising_edge;
    end

endmodule