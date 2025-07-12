module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    // Combinational decrement function using ripple borrow approach
    function [3:0] decrement;
        input [3:0] val;
        reg borrow;
        integer i;
        begin
            borrow = 1'b1;
            decrement = val;
            for (i = 0; i < 4; i = i + 1) begin
                decrement[i] = val[i] ^ borrow;
                borrow = (~val[i]) & borrow;
            end
        end
    endfunction

    always @(posedge clk) begin
        if (count_ena) begin
            // Decrement q by 1
            q <= decrement(q);
        end else if (shift_ena) begin
            // Shift left by one, data goes to LSB (MSB-first)
            q <= {q[2:0], data};
        end else begin
            q <= q; // Hold state
        end
    end

endmodule