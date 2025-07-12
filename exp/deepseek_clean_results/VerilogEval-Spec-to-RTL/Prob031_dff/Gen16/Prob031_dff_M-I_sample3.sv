module TopModule(
    input clk,
    input d,
    output reg q,
    input rst_n = 1'b1,    // Optional async reset (active low)
    input en = 1'b1        // Optional clock enable
);
    // synthesis attribute: Use smallest available flip-flop cell
    (* use_smallest_ff = "true" *)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1'b0;
        else if (en)
            q <= d;
    end
endmodule