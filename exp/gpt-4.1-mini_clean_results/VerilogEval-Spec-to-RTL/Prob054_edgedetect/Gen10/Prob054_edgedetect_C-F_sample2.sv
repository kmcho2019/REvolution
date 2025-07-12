module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Stage 1: Register previous input vector for stable comparison
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational edge detection: detect bits transitioning from 0 to 1
    assign edge_detect = (~prev_in) & in;

    // Stage 2: Register output pulses one clock cycle after edge detection
    always @(posedge clk) begin
        pedge <= edge_detect;
    end

endmodule