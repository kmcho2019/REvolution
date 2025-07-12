module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire update_enable;

    // Enable update only if input has changed since last stored value
    assign update_enable = |(prev_in ^ in);

    always @(posedge clk) begin
        pedge <= (~prev_in) & in;
        if (update_enable)
            prev_in <= in;
    end

endmodule