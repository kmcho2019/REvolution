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
            1'b1: begin // count up with saturation at max
                if (count != 16'hFFFF)
                    count <= count + 16'd1;
                else
                    count <= 16'hFFFF;
            end
            1'b0: begin // count down with saturation at zero
                if (count != 16'd0)
                    count <= count - 16'd1;
                else
                    count <= 16'd0;
            end
        endcase
    end
end

endmodule