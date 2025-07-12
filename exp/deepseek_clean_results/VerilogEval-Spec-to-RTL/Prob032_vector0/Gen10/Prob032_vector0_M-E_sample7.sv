module TopModule (
    input [2:0] vec,
    output reg [2:0] outv,
    output o2, o1, o0,
    input clk,    // Added clock for shift register
    input load    // Added load control
);

    reg [2:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= vec;
        end
    end

    assign outv = shift_reg;
    assign {o2, o1, o0} = shift_reg;

endmodule