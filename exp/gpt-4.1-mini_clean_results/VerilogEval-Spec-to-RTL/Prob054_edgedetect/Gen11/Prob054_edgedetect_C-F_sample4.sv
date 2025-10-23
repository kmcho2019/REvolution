module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Combinational edge detection: bits that transitioned from 0 to 1
    assign edge_detect = (~prev_in) & in;

    // Register previous input to sample current state
    always @(posedge clk) begin
        prev_in <= in;
        // Optional clock enable for power saving if input stable (commented out):
        // if (in != prev_in)
        //     prev_in <= in;
    end

    // Register output pulses one cycle after edge detection
    always @(posedge clk) begin
        pedge <= edge_detect;
    end

endmodule