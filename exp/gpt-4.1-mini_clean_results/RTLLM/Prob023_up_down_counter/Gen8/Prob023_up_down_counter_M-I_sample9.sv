module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

    wire [15:0] inc_val;
    wire [15:0] dec_val;

    assign inc_val = count + 16'd1;
    assign dec_val = count - 16'd1;

    always @(posedge clk) begin
        if (reset)
            count <= 16'd0;
        else
            count <= up_down ? inc_val : dec_val;
    end

endmodule