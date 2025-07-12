module TopModule (
    input clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] change;

    assign change = in ^ prev_in;

    always @(posedge clk) begin
        anyedge <= change;
        if (|change)            // Update prev_in only if any bit changed
            prev_in <= in;
    end

endmodule