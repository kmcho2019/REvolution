module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

    always @(posedge clk) begin
        if (reset)
            count <= 16'd0;
        else if (1'b1) begin // enable always true, but can be gated if needed
            if (up_down)
                count <= count + 16'd1;
            else
                count <= count - 16'd1;
        end
    end

endmodule