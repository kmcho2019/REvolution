module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] cycle_count;

    always @(posedge clk) begin
        if (reset) begin
            cycle_count <= 2'b00;
        end else if (cycle_count < 2'b11) begin
            cycle_count <= cycle_count + 1;
        end
    end

    assign shift_ena = (cycle_count < 2'b11) | reset;

endmodule