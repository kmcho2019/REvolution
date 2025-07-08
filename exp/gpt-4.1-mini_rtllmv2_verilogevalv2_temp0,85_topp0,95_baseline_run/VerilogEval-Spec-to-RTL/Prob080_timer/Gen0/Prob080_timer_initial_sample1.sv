module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);
    // Internal 10-bit counter register
    reg [9:0] count;

    // Single D flip-flop for LSB
    reg lsb_dff;

    // Combinational logic for next count
    wire [9:1] count_next;

    // Assign next value for bits 9 down to 1
    // When load=1, load data bits; else decrement if not zero.
    assign count_next = (load) ? data[9:1] :
                        (count != 10'd0) ? (count[9:1] - (count[0] ? 10'd0 : 10'd1)) : count[9:1];
    // Note: The above logic is tricky because we only have one D flip-flop for LSB,
    // so decrement logic for upper bits depends on LSB.

    // But since only one DFF allowed, we need to implement the entire counter except LSB in combinational logic.
    // We can implement the decrement by subtracting 1 from the entire count when load=0 and count != 0.
    // Since LSB is stored in D flip-flop, on clock edge we update it separately.

    // Let's implement a decrementer for upper bits based on current count and LSB.

    // The decrement logic for bits [9:1] when load=0 and count != 0:
    // If LSB=1, then upper bits do not borrow, so count[9:1] stays same.
    // If LSB=0, borrow from upper bits is needed, so upper bits decrement by 1.

    // So:
    // next upper bits = (load) ? data[9:1] : 
    //                   (count != 0) ? (count[9:1] - (~count[0])) : count[9:1];

    wire borrow = ~count[0];
    wire [9:1] upper_next = load ? data[9:1] :
                           (count != 10'd0) ? (count[9:1] - borrow) : count[9:1];

    always @(posedge clk) begin
        if (load) begin
            count[9:1] <= data[9:1];
            lsb_dff <= data[0];
        end else if (count != 10'd0) begin
            count[9:1] <= upper_next;
            lsb_dff <= ~lsb_dff; // toggle LSB when counting down
        end
        // else hold count when zero
    end

    // Compose the full count value
    always @(*) begin
        count[0] = lsb_dff;
    end

    assign tc = (count == 10'd0);

endmodule