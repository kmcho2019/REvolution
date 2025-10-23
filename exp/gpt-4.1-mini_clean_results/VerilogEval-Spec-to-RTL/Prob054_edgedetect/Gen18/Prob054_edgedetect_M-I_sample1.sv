module TopModule (
    input          clk,
    input   [7:0]  in,
    output  reg [7:0] pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Update prev_in only if input changed to reduce toggling power
        if (in != prev_in)
            prev_in <= in;

        pedge <= in & ~prev_in;
    end

endmodule