module TopModule (
    input          clk,
    input          ce,
    input   [7:0]  in,
    output reg [31:0] out
);

    always @(posedge clk) begin
        if (ce)
            out <= {{24{in[7]}}, in};
    end

endmodule