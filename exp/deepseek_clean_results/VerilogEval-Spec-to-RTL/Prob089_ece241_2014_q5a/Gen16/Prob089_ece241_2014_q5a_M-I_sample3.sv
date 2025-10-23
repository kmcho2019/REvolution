module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            z <= 1'b0;
        end else begin
            z <= z ? ~x : x;
            if (!z && x) z <= 1'b1;  // Start inverting once we see first '1'
        end
    end

endmodule