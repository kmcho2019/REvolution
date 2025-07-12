module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding: carry indicates if carry (first '1') has been seen
    reg carry;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            carry <= 1'b0;
            z <= 1'b0;
        end else begin
            if (!carry) begin
                z <= x;             // output input until first '1'
                carry <= (x == 1'b1) ? 1'b1 : 1'b0;
            end else begin
                z <= ~x;            // invert bits after carry started
                carry <= 1'b1;      // remain in carry state
            end
        end
    end

endmodule