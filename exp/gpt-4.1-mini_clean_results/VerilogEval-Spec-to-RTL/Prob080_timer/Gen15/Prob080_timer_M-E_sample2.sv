module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    // Store only the LSB in a single D flip-flop
    reg counter_lsb;

    // Hold the upper 9 bits in a register made by latch or combinational logic (using a reg here for clarity)
    reg [8:0] counter_upper;

    wire [9:0] current_count = {counter_upper, counter_lsb};

    wire [9:0] next_count;

    // Next count logic: on load, load data; else decrement if not zero; else hold zero
    assign next_count = load ? data :
                        (current_count == 10'd0 ? 10'd0 : current_count - 10'd1);

    // Update registers at positive edge clock
    always @(posedge clk) begin
        counter_upper <= next_count[9:1];
        counter_lsb <= next_count[0];
    end

    // Terminal count when counter is zero
    assign tc = (current_count == 10'd0);

endmodule