module TopModule (
    input           clk,
    input   [7:0]   in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] pedge_next;

    // Combinational positive edge detection logic
    assign pedge_next = in & ~prev_in;

    // Register previous input and pedge output synchronously
    always @(posedge clk) begin
        prev_in <= in;
        pedge   <= pedge_next;
    end

endmodule