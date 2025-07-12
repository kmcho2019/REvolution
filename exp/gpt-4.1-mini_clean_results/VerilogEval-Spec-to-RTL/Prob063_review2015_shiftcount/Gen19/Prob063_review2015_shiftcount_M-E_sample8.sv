module TopModule(
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    // Ripple borrow subtraction by 1 (q - 1) implemented explicitly
    function [3:0] decrement;
        input [3:0] val;
        reg borrow0, borrow1, borrow2, borrow3;
        reg bit0, bit1, bit2, bit3;
        begin
            // bit 0
            bit0 = val[0] ^ 1'b1;
            borrow0 = ~val[0];
            // bit 1
            bit1 = val[1] ^ borrow0;
            borrow1 = ~val[1] & borrow0;
            // bit 2
            bit2 = val[2] ^ borrow1;
            borrow2 = ~val[2] & borrow1;
            // bit 3
            bit3 = val[3] ^ borrow2;
            borrow3 = ~val[3] & borrow2;
            decrement = {bit3, bit2, bit1, bit0};
        end
    endfunction

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift left, MSB first: data enters LSB, left-shift the register
            q <= {q[2:0], data};
        end else if (count_ena) begin
            // Decrement q by 1 using explicit ripple borrow function
            q <= decrement(q);
        end else begin
            // Hold state if neither enabled
            q <= q;
        end
    end

endmodule