module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;

    // Store the input of the current cycle to compare on the next cycle
    always @(posedge clk) begin
        prev_in <= in;
    end

    // anyedge is high if the input changed compared to previous cycle
    assign anyedge = in ^ prev_in;

endmodule