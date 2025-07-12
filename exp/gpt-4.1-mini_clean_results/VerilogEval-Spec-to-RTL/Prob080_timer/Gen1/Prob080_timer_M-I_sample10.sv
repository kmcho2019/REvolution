module TopModule (
    input        clk,
    input        load,
    input  [9:0] data,
    output       tc
);

    // Unified 10-bit counter register
    // LSB implemented with an explicit D flip-flop instance for compliance
    reg [9:1] count_upper;
    reg count_lsb;

    wire [9:0] count = {count_upper, count_lsb};

    wire zero = (count == 10'd0);
    assign tc = zero;

    // Compute next counter value
    // When load=1: load data
    // When load=0 and not zero: decrement by 1
    // When zero and load=0: hold zero

    wire [9:0] load_val = data;

    // Ripple borrow decrement logic:
    // Decrement only if not zero and load=0
    // We'll generate next bits with ripple borrow chain from LSB to MSB

    wire dec_en = ~load & ~zero; // enable decrement

    // Compute next value for LSB
    wire count_lsb_next;
    wire borrow0 = dec_en & count_lsb; // borrow if decrement enabled and LSB is 1

    assign count_lsb_next = load ? load_val[0] : (dec_en ? ~count_lsb : count_lsb);

    // For upper bits, propagate borrow:
    reg [8:1] count_upper_next;
    integer i;
    reg borrow;

    always @* begin
        borrow = dec_en; // borrow in to bit1 if decrement enabled
        for (i = 1; i <= 9; i = i + 1) begin
            if (load) begin
                count_upper_next[i-1] = load_val[i];
            end else if (~zero) begin
                // decrement bit with borrow
                if (count_upper[i-1] == 1'b0 && borrow) begin
                    count_upper_next[i-1] = 1'b1;
                    borrow = 1'b1; // borrow continues
                end else begin
                    count_upper_next[i-1] = count_upper[i-1] ^ borrow;
                    borrow = 1'b0; // borrow cleared
                end
            end else begin
                // hold value at zero
                count_upper_next[i-1] = count_upper[i-1];
            end
        end
    end

    // Explicit D flip-flop for LSB
    always @(posedge clk) begin
        count_lsb <= count_lsb_next;
    end

    // Other bits as registers (inferred flip-flops)
    always @(posedge clk) begin
        count_upper <= count_upper_next;
    end

endmodule