module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire update_enable;

    // Enable register update only when input changes to save dynamic power
    assign update_enable = (in != prev_in);

    always @(posedge clk) begin
        pedge <= (~prev_in) & in;
        if (update_enable)
            prev_in <= in;
    end

endmodule