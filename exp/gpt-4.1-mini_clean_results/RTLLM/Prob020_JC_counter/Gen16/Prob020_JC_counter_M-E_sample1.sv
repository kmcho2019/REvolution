module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        // Rotate right by 1 bit
        wire [63:0] rotated = {Q[0], Q[63:1]};
        // If LSB of Q is 0, invert MSB of rotated, else leave as is
        if (Q[0] == 1'b0) begin
            Q <= {~rotated[63], rotated[62:0]};
        end else begin
            Q <= rotated;
        end
    end
end

endmodule