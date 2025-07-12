module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Generate edge detectors for each bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : edge_detectors
            assign edge_detect[i] = in[i] ^ prev_in[i];
        end
    endgenerate

    // Output register
    reg [7:0] anyedge_reg;
    assign anyedge = anyedge_reg;

    // Sequential update
    always @(posedge clk) begin
        prev_in <= in;
        anyedge_reg <= edge_detect;
    end

endmodule