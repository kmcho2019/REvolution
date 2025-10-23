module TopModule (
    input clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire update_en;

    assign update_en = (in != prev_in);

    always @(posedge clk) begin
        anyedge <= in ^ prev_in;
        if (update_en)
            prev_in <= in;
    end

endmodule