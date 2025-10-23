module LFSR(
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    wire feedback;
    wire [3:0] next_out;

    // Calculate feedback: inversion of XOR of MSB and second MSB
    assign feedback = ~(out[3] ^ out[2]);

    // Next state computation: shift left and insert feedback at LSB
    assign next_out = {out[2:0], feedback};

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0001;
        else
            out <= next_out;
    end

endmodule