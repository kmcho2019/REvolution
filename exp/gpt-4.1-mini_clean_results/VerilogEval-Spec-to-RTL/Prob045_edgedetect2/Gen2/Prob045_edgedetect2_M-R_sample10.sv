module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edges_detected;

    assign edges_detected = in ^ prev_in;

    always @(posedge clk) begin
        anyedge <= edges_detected;
        prev_in <= in;
    end

endmodule