module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 16'd0;
        end else if (up_down) begin
            // Saturate at max (65535)
            if (count != 16'hFFFF)
                count <= count + 16'd1;
            else
                count <= count; // Hold max
        end else begin
            // Saturate at min (0)
            if (count != 16'd0)
                count <= count - 16'd1;
            else
                count <= count; // Hold min
        end
    end

endmodule