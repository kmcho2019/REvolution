module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detected;

    // Combinational detection of 0->1 edges per bit
    assign edge_detected = (~prev_in) & in;

    always @(posedge clk) begin
        pedge   <= edge_detected;  // Register detected edges, output delayed by 1 cycle
        prev_in <= in;             // Update previous input for next cycle comparison
    end

endmodule