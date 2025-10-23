module right_shifter #(
    parameter WIDTH = 8
) (
    input wire clk,
    input wire reset_n,
    input wire d,
    input wire load,
    input wire [WIDTH-1:0] parallel_in,
    output reg [WIDTH-1:0] q
);

reg [WIDTH-1:0] shift_reg_stage1;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        shift_reg_stage1 <= {WIDTH{1'b0}};
        q <= {WIDTH{1'b0}};
    end
    else begin
        // First pipeline stage
        if (load) begin
            shift_reg_stage1 <= parallel_in;
        end
        else begin
            shift_reg_stage1 <= {d, q[WIDTH-1:1]};
        end

        // Second pipeline stage (output register)
        q <= shift_reg_stage1;
    end
end

endmodule