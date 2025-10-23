module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Function to perform the shift operation based on amount and q
    function [63:0] shifted_val;
        input [63:0] val;
        input [1:0] amt;
        reg dir_right;
        reg shift_8;
        reg [63:0] result;
        begin
            dir_right = amt[1];
            shift_8 = amt[0];
            if (!dir_right) begin
                // Shift left
                if (shift_8)
                    result = {val[55:0], 8'b0};
                else
                    result = {val[62:0], 1'b0};
            end else begin
                // Arithmetic shift right
                if (shift_8)
                    result = {{8{val[63]}}, val[63:8]};
                else
                    result = {val[63], val[63:1]};
            end
            shifted_val = result;
        end
    endfunction

    // Next state logic
    wire [63:0] next_q = load ? data : (ena ? shifted_val(q, amount) : q);

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule