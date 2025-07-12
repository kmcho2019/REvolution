module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    reg [1:0] shift_count;

    always @(posedge clk) begin
        if (reset) begin
            shift_count <= 2'd3;  // 4 cycles including current cycle: counts down 3,2,1,0
            shift_ena <= 1'b1;
        end else begin
            if (shift_count != 2'd0) begin
                shift_count <= shift_count - 1;
                shift_ena <= 1'b1;
            end else begin
                shift_ena <= 1'b0;
            end
        end
    end

endmodule