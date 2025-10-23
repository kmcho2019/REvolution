module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detected;

    // Register input for edge comparison
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational logic for edge detection
    assign edge_detected = (~prev_in) & in;

    // Register the detected edge output
    always @(posedge clk) begin
        pedge <= edge_detected;
    end

endmodule