module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] next_q;

    always @(*) begin
        // Use arithmetic increment for efficient next state calculation
        next_q = q + 4'b0001;
    end

    always @(posedge clk) begin
        if (reset)
            q <= 4'b0000;
        else
            q <= next_q;
    end

endmodule