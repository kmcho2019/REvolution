module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

    reg [3:0] next_state;
    wire feedback;

    assign feedback = ~(out[3] ^ out[2]);

    // Combinational logic to calculate next state
    always @(*) begin
        next_state = {out[2:0], feedback};
    end

    // Sequential logic to update the state
    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0000;
        end else begin
            out <= next_state;
        end
    end

endmodule