module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    reg [2:0] cycle_count;

    always @(posedge clk) begin
        if (reset) begin
            cycle_count <= 3'd0;
            shift_ena <= 1'b1;
        end else if (cycle_count < 3'd3) begin
            cycle_count <= cycle_count + 1;
            shift_ena <= 1'b1;
        end else begin
            shift_ena <= 1'b0;
        end
    end

endmodule