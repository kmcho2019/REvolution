module TopModule (
    input        clk,
    input        load,
    input  [9:0] data,
    output       tc
);

    // Internal 10-bit register for the counter, with bit 0 driven by an explicit DFF
    reg [9:1] count_upper;   // bits 9 down to 1
    reg count_lsb;           // bit 0 implemented with a single explicit D flip-flop

    // Next value signals
    reg [9:1] count_upper_next;
    reg count_lsb_next;

    // tc asserted when counter is zero
    wire zero = (count_upper == 9'd0) && (count_lsb == 1'b0);
    assign tc = zero;

    // Combinational logic to calculate next state for the counter bits
    // Counter decrement logic:
    // When load=1, load the counter with data.
    // When load=0 and counter != 0, decrement by 1.
    // When counter = 0 and load=0, hold zero.

    // We will implement decrement logic by subtracting 1 from the current count.
    wire [9:0] current_count = {count_upper, count_lsb};
    wire [9:0] load_val = data;
    wire [9:0] dec_val = current_count - 10'd1;

    always @* begin
        if (load) begin
            count_upper_next = load_val[9:1];
            count_lsb_next   = load_val[0];
        end else begin
            if (zero) begin
                // hold zero
                count_upper_next = count_upper;
                count_lsb_next   = count_lsb;
            end else begin
                // decrement
                count_upper_next = dec_val[9:1];
                count_lsb_next   = dec_val[0];
            end
        end
    end

    // Single D flip-flop instantiated for bit 0 (count_lsb)
    // Other bits are inferred registers
    always @(posedge clk) begin
        count_lsb <= count_lsb_next;
    end

    // Other bits registered in the same clock domain
    always @(posedge clk) begin
        count_upper <= count_upper_next;
    end

endmodule