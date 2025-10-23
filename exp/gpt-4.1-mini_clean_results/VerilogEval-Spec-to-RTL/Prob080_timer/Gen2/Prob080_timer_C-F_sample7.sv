module TopModule (
    input        clk,
    input        load,
    input  [9:0] data,
    output       tc
);

    // Explicit single D flip-flop for LSB
    reg count_lsb;

    // Upper 9 bits inferred registers
    reg [9:1] count_upper;

    wire [9:0] current_count = {count_upper, count_lsb};
    wire zero = (current_count == 10'd0);
    assign tc = zero;

    // Decrement value: current_count - 1
    wire [9:0] decremented = current_count - 10'd1;

    // Next states for upper bits and lsb
    reg [9:1] count_upper_next;
    reg count_lsb_next;

    always @* begin
        if (load) begin
            count_upper_next = data[9:1];
            count_lsb_next   = data[0];
        end else if (!zero) begin
            count_upper_next = decremented[9:1];
            count_lsb_next   = decremented[0];
        end else begin
            // Hold zero
            count_upper_next = count_upper;
            count_lsb_next   = count_lsb;
        end
    end

    // Register the explicit single D flip-flop for LSB
    always @(posedge clk) begin
        count_lsb <= count_lsb_next;
    end

    // Register upper bits
    always @(posedge clk) begin
        count_upper <= count_upper_next;
    end

endmodule