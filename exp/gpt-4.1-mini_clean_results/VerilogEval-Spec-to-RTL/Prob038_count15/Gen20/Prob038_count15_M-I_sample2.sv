module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] next_q;

    always @* begin
        // Use simple arithmetic increment to allow synthesis to optimize carry chains
        next_q = q + 4'b0001;
    end

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;
        end else begin
            q <= next_q;
        end
    end
endmodule