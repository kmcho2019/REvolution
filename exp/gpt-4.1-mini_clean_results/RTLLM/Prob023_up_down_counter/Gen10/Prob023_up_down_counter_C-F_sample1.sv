module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

    always @(posedge clk) begin
        if (reset)
            count <= 16'd0;
        else
            count <= count + (up_down ? 16'd1 : 16'hFFFF);
    end

endmodule