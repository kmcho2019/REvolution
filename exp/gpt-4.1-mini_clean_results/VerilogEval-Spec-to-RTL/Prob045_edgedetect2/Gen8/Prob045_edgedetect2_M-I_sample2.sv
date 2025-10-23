module TopModule (
    input clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;
    wire input_changed;

    // Detect if input changed compared to prev_in
    assign input_changed = |(in ^ prev_in);
    // Edge detection: XOR current and previous input bits
    assign edge_detect = in ^ prev_in;

    // Register prev_in only when input has changed to save power
    always @(posedge clk) begin
        if (input_changed)
            prev_in <= in;
    end

    // Register edge_detect to produce anyedge with one cycle delay
    always @(posedge clk) begin
        anyedge <= edge_detect;
    end

endmodule