module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    wire feedback;
    reg  [3:0] next_state;

    // Combinational logic to compute feedback and next state
    assign feedback = ~(out[3] ^ out[2]);
    always @(*) begin
        next_state = {out[2:0], feedback};
    end

    // Sequential logic to update state
    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;
        else
            out <= next_state;
    end

endmodule