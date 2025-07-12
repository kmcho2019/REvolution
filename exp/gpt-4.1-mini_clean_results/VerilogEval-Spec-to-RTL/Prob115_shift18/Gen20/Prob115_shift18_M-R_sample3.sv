module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    // Function for logical left shift by N bits
    function [63:0] shift_left;
        input [63:0] val;
        input [5:0]  n; // max 64
        begin
            shift_left = (val << n);
        end
    endfunction

    // Function for arithmetic right shift by N bits
    function [63:0] shift_right_arith;
        input [63:0] val;
        input [5:0]  n; // max 64
        reg sign;
        begin
            sign = val[63];
            shift_right_arith = (val >> n);
            if (n != 0) begin
                // Sign extend upper bits
                shift_right_arith[63 -: n] = {n{sign}};
            end
        end
    endfunction

    reg [63:0] next_q;

    always @(*) begin
        if (load) begin
            next_q = data;
        end else if (ena) begin
            case (amount)
                2'b00: next_q = shift_left(q, 1);
                2'b01: next_q = shift_left(q, 8);
                2'b10: next_q = shift_right_arith(q, 1);
                2'b11: next_q = shift_right_arith(q, 8);
                default: next_q = q;
            endcase
        end else begin
            next_q = q;
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule