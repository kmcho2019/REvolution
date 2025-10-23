module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    // Register the previous input only when it changes to reduce switching activity
    always @(posedge clk) begin
        if (in != prev_in)
            prev_in <= in;
    end

    // Generate anyedge one cycle after the input transitions, by XORing current and previous inputs
    always @(posedge clk) begin
        anyedge <= in ^ prev_in;
    end

endmodule