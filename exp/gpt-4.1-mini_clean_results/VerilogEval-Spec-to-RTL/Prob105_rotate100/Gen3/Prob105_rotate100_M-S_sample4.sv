module TopModule (
    input         clk,
    input         load,
    input  [1:0]  ena,
    input  [99:0] data,
    output [99:0] q
);

    reg [99:0] reg_data;

    always @(posedge clk) begin
        if (load)
            reg_data <= data;
        else if (ena == 2'b01)
            reg_data <= {reg_data[0], reg_data[99:1]};  // rotate right
        else if (ena == 2'b10)
            reg_data <= {reg_data[98:0], reg_data[99]}; // rotate left
        // else hold reg_data
    end

    assign q = reg_data;

endmodule