module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

    always @(posedge clk) begin
        if (reset)
            count <= 0;
        else
            count <= up_down ? count + 1 : count - 1;
    end

endmodule