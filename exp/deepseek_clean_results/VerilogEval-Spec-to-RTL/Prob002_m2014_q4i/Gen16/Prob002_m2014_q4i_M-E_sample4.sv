module TopModule (
    output reg out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 1'b0;
        end
    end

    // Tie reset high to ensure constant output of 0
    wire reset = 1'b1;
    wire clk;  // Unused clock
endmodule