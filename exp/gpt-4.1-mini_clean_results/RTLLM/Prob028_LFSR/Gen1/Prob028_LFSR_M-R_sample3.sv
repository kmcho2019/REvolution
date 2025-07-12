module LFSR(
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

    wire feedback;
    reg [3:0] next_out;

    // Calculate feedback as inverted XOR of out[3] and out[2]
    assign feedback = ~(out[3] ^ out[2]);

    // Combinational logic for next state
    always @(*) begin
        next_out = {out[2:0], feedback};
    end

    // Sequential logic: update state on rising clock edge or reset
    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;
        else
            out <= next_out;
    end

endmodule