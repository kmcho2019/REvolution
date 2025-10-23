module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 16'd0;
        end else begin
            case (up_down)
                1'b1: count <= count + 16'd1;  // Count up
                1'b0: count <= count - 16'd1;  // Count down
                default: count <= count;        // Should never occur
            endcase
        end
    end

endmodule