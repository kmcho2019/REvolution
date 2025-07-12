module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] cycle_count;

    assign shift_ena = (cycle_count < 2'd3);

    always @(posedge clk) begin
        if (reset) begin
            cycle_count <= 2'd0;
        end else if (shift_ena) begin
            cycle_count <= cycle_count + 1;
        end
    end

endmodule