module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
            shift_ena <= 1'b1;
        end else begin
            if (shift_ena) begin
                if (count == 3'd3) begin
                    shift_ena <= 1'b0;
                end
                count <= count + 1'b1;
            end
        end
    end

endmodule