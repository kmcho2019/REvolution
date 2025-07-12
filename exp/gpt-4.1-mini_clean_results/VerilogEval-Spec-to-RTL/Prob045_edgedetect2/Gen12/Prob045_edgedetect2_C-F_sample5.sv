module TopModule (
    input          clk,
    input   [7:0]  in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Register previous input on clock edge
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational XOR detects edges by comparing current and previous inputs
    assign edge_detect = in ^ prev_in;

    // Register edge_detect output to produce one-cycle delayed anyedge
    always @(posedge clk) begin
        anyedge <= edge_detect;
    end

endmodule