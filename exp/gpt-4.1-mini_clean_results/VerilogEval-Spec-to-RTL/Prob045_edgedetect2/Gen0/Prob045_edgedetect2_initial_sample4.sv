module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detected;

    always @(posedge clk) begin
        edge_detected <= prev_in ^ in; // Detect edges from prev_in to in
        prev_in <= in;
    end

    // Output the edge_detected from the previous cycle
    // so anyedge is high the cycle after the edge occurs
    reg [7:0] anyedge_reg;

    always @(posedge clk) begin
        anyedge_reg <= edge_detected;
    end

    assign anyedge = anyedge_reg;

endmodule