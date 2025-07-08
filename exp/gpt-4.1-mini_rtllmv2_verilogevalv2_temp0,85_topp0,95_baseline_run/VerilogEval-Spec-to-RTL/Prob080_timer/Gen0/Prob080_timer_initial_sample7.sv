module DFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);
    // Internal signals
    reg [9:1] count_high; // bits 9 down to 1
    wire count0_d;        // D input for LSB flip-flop
    wire count0_q;        // Q output from LSB flip-flop
    wire load_active;
    wire [9:1] count_high_next;
    wire count_is_zero;

    assign load_active = load;

    // Instantiate single D flip-flop for LSB bit
    DFF dff0 (
        .clk(clk),
        .d(count0_d),
        .q(count0_q)
    );

    // Combinational logic for next value of count_high bits
    // When load=1, next count = data
    // When load=0 and counter not zero, next count = current count - 1
    // When counter is zero, stays zero

    // Combine current count bits
    wire [9:0] count_current = {count_high, count0_q};

    // Determine if count is zero
    assign count_is_zero = (count_current == 10'b0);
    assign tc = count_is_zero;

    // Next count logic
    wire [9:0] count_next_load = data;
    wire [9:0] count_next_dec = count_current - 1;

    wire [9:0] count_next = load_active ? count_next_load :
                           (count_is_zero ? 10'b0 : count_next_dec);

    // Next count_high bits
    assign count_high_next = count_next[9:1];
    // Next count0 bit for DFF input
    assign count0_d = count_next[0];

    // Sequential logic for count_high bits (bits 9:1)
    always @(posedge clk) begin
        count_high <= count_high_next;
    end
endmodule