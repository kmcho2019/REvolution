// Simplified TopModule with 8-bit D Flip-Flop and active high asynchronous reset
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Use a reg to hold the output value
    reg [7:0] q;

    // Always block triggered on positive edge of clk or posedge of areset
    always @(posedge clk or posedge areset) begin
        // If areset is high, reset q to 0
        if (areset) begin
            q <= 8'b0;
        end 
        // Otherwise, update q with the input d on the positive edge of clk
        else begin
            q <= d;
        end
    end

endmodule