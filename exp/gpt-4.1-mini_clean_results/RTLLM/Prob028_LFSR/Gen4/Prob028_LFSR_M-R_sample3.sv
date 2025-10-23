module LFSR (
    input  wire       clk,
    input  wire       rst,    // Active high synchronous reset
    output reg  [3:0] out
);

    reg feedback;

    // Combinational block for feedback calculation
    always @(*) begin
        feedback = ~(out[3] ^ out[2]);
    end

    // Sequential block for register update with synchronous reset
    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;
        else
            out <= {out[2:0], feedback};
    end

endmodule