module TopModule (
    input           clk,
    input           load,
    input           ena,
    input    [1:0]  amount,
    input    [63:0] data,
    output reg [63:0] q
);

    reg [63:0] shift_res;

    // Generate arithmetic right shift mask for sign extension
    function [63:0] arith_mask;
        input [63:0] val;
        input [5:0]  shift_amt;
        integer i;
        begin
            arith_mask = 64'b0;
            if (val[63] == 1'b1) begin
                for (i = 0; i < shift_amt; i = i +1) begin
                    arith_mask[i] = 1'b1;
                end
            end
        end
    endfunction

    always @(*) begin
        case (amount)
            2'b00: begin // shift left by 1
                shift_res = {q[62:0], 1'b0};
            end
            2'b01: begin // shift left by 8
                shift_res = {q[55:0], 8'b0};
            end
            2'b10: begin // arithmetic shift right by 1
                shift_res = (q >> 1) | arith_mask(q, 1);
            end
            2'b11: begin // arithmetic shift right by 8
                shift_res = (q >> 8) | arith_mask(q, 8);
            end
            default: begin
                shift_res = q; // default hold value
            end
        endcase
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shift_res;
        end
    end

endmodule