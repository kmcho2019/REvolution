module TopModule (
    input         clk,
    input         load,
    input  [1:0]  ena,
    input  [99:0] data,
    output reg [99:0] q
);

    wire rotate_left  = (ena == 2'b10);
    wire rotate_right = (ena == 2'b01);
    wire clk_en      = load | rotate_left | rotate_right;

    wire [99:0] rotated_data;

    // Rotate left by 1
    assign rotated_data = rotate_left ? {q[98:0], q[99]} :
                          rotate_right ? {q[0], q[99:1]} :
                          q;

    always @(posedge clk) begin
        if (clk_en) begin
            if (load) begin
                q <= data;
            end else begin
                q <= rotated_data;
            end
        end
        // else retain q without toggling (clock gating effect)
    end

endmodule