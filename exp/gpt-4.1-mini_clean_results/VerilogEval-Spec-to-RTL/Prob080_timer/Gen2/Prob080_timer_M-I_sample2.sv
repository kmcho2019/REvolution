module TopModule (
    input        clk,
    input        load,
    input  [9:0] data,
    output       tc
);

    // 10-bit counter register: count[0] is the LSB, implemented by explicit D flip-flop,
    // count[9:1] are upper bits as inferred registers.
    reg [9:1] count_upper;
    reg       count_lsb;

    // Combinational decrement with ripple borrow
    // next_count = current_count - 1 if not zero and load=0, else load data if load=1, else hold zero
    // Use simple bitwise ripple borrow logic for decrement.

    wire zero = (count_upper == 9'd0) && (count_lsb == 1'b0);
    assign tc = zero;

    // Next value signals
    reg [9:1] count_upper_next;
    reg       count_lsb_next;

    always @* begin
        if (load) begin
            // Load data directly
            count_upper_next = data[9:1];
            count_lsb_next   = data[0];
        end else if (zero) begin
            // Hold zero
            count_upper_next = count_upper;
            count_lsb_next   = count_lsb;
        end else begin
            // Decrement by 1 using ripple borrow subtractor
            // Bit 0: count_lsb_next = ~count_lsb (borrow = count_lsb)
            // For each upper bit i: count_upper_next[i] = count_upper[i] - borrow
            // borrow ripples if bit[i] == 0 and borrow_in=1
            reg borrow;
            integer i;
            borrow = count_lsb;  // borrow from LSB decrement: if LSB=0 borrow=1 else 0
            count_lsb_next = ~count_lsb; // decrement LSB is toggling its bit

            // Compute upper bits decrement ripple borrow
            count_upper_next = count_upper; // init
            for (i = 1; i <= 9; i = i + 1) begin
                if (borrow) begin
                    if (count_upper[i]) begin
                        // no further borrow
                        count_upper_next[i] = 1'b0;
                        borrow = 1'b0;
                    end else begin
                        count_upper_next[i] = 1'b1;
                        borrow = 1'b1;
                    end
                end else begin
                    count_upper_next[i] = count_upper[i];
                end
            end
        end
    end

    // Single D flip-flop for LSB bit
    always @(posedge clk) begin
        count_lsb <= count_lsb_next;
    end

    // Register for upper bits
    always @(posedge clk) begin
        count_upper <= count_upper_next;
    end

endmodule