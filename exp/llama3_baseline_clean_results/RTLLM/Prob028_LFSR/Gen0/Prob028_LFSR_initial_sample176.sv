module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

    reg [3:0] state;

    always @(posedge clk) begin
        if (rst) begin
            state <= 4'b0000;
        end else begin
            reg feedback;
            feedback = ~(state[3] ^ state[2]);
            state <= {state[2:0], feedback};
        end
    end

    assign out = state;

endmodule