module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] next_q;

    always @* begin
        // Use arithmetic increment to leverage optimized carry logic in synthesis
        next_q = q + 1;
    end

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;
        end else begin
            q <= next_q;
        end
    end

endmodule