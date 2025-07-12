module TopModule (
    input clk,
    input d,
    output reg q
);
    // Internal asynchronous reset signal tied to 0 (inactive)
    wire reset_n = 1'b1;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule