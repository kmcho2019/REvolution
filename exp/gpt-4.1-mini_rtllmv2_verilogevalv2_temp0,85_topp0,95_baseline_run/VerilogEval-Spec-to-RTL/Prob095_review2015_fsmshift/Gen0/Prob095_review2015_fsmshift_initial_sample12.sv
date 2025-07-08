module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

    reg [1:0] count;
    reg enabled;

    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b1;
            count <= 2'd1;
            enabled <= 1'b1;
        end else if (enabled) begin
            if (count == 2'd4) begin
                shift_ena <= 1'b0;
                enabled <= 1'b0;
            end else begin
                count <= count + 2'd1;
                shift_ena <= 1'b1;
            end
        end else begin
            shift_ena <= 1'b0;
        end
    end

endmodule