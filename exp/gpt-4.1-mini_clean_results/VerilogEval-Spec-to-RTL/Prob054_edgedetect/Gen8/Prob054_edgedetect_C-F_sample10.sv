module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Register previous input to sample current state
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational edge detection: bits that transitioned from 0 to 1
    assign edge_detect = (~prev_in) & in;

    // Register output pulses one cycle after edge detection
    always @(posedge clk) begin
        pedge <= edge_detect;
    end

endmodule