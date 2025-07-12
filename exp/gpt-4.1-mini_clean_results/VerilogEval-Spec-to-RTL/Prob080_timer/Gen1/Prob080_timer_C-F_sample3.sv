module TopModule (
    input        clk,
    input        load,
    input  [9:0] data,
    output       tc
);

    // Internal 10-bit counter: bit 0 stored in a single explicit D flip-flop
    reg [9:1] count_upper;
    reg       count_lsb;

    // Signals for next state
    reg [9:1] count_upper_next;
    reg       count_lsb_next;

    // Current counter value concatenated
    wire [9:0] current_count = {count_upper, count_lsb};

    // Terminal count: asserted when counter == 0
    assign tc = (current_count == 10'd0);

    // Next state logic
    // When load is asserted, load the counter with input data
    // When load is deasserted:
    //   - if counter != 0, decrement by 1
    //   - if counter == 0, hold zero (no change)
    wire zero = (current_count == 10'd0);
    wire [9:0] decremented = current_count - 10'd1;

    always @* begin
        if (load) begin
            count_upper_next = data[9:1];
            count_lsb_next   = data[0];
        end else if (!zero) begin
            count_upper_next = decremented[9:1];
            count_lsb_next   = decremented[0];
        end else begin
            // Hold zero state
            count_upper_next = count_upper;
            count_lsb_next   = count_lsb;
        end
    end

    // Single explicit D flip-flop for LSB bit
    always @(posedge clk) begin
        count_lsb <= count_lsb_next;
    end

    // Inferred registers for upper bits
    always @(posedge clk) begin
        count_upper <= count_upper_next;
    end

endmodule