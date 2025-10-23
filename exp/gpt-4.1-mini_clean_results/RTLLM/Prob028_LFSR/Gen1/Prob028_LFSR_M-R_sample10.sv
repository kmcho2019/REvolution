module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

    reg feedback;
    reg [3:0] next_state;

    // Combinational logic to compute feedback and next state
    always @(*) begin
        feedback = ~(out[3] ^ out[2]);
        next_state = {out[2:0], feedback};
    end

    // Sequential logic for register update
    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0000;
        end else begin
            out <= next_state;
        end
    end

endmodule