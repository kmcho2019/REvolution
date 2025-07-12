module up_down_counter (
    input  wire        clk,
    input  wire        reset,
    input  wire        up_down,
    output reg [15:0]  count
);

    reg [15:0] inc_val;
    reg [15:0] dec_val;

    always @(posedge clk) begin
        if (reset) begin
            count <= 16'd0;
            inc_val <= 16'd0;
            dec_val <= 16'd0;
        end else begin
            inc_val <= count + 16'd1;
            dec_val <= count - 16'd1;
            count <= up_down ? inc_val : dec_val;
        end
    end

endmodule