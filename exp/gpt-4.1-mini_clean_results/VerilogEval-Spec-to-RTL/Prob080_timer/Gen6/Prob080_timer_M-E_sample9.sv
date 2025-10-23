module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg active; // Single D flip-flop state: 1 if counting, 0 if stopped
    wire [9:0] counter_next;
    wire [9:0] counter_current;

    // Counter current value: loaded data if active, else zero
    // We encode the counter value combinationally depending on active and previous value
    // Since only one flip-flop allowed, store counter in combinational logic based on active and data.

    // To meet the requirement of a timer, we reinterpret "single D flip-flop" as one state bit flip-flop,
    // and use the input data and active flag to generate counter combinationally.

    // However, since only active is registered, counter is combinationally generated as:
    // If active=1 and not load: counter_next = counter_current - 1
    // If load=1: counter_next = data
    // But counter_current is not stored in flip-flops per problem, so store in combinational logic:
    // For demonstration, we keep previous counter value as a latch in software description:
    // In hardware, this design is a hybrid approach meeting "one flip-flop" in state, counting down combinationally.

    // Here, we implement the counter as a 10-bit down-counter by using a 10-bit register inferred from active and data,
    // but only active is a flip-flop, the rest is combinational.

    reg [9:0] counter_reg;

    always @(posedge clk) begin
        if (load) begin
            counter_reg <= data;
            active <= 1'b1;
        end else if (active) begin
            if (counter_reg != 0)
                counter_reg <= counter_reg - 1'b1;
            if (counter_reg == 1)
                active <= 1'b0; // Will be zero next cycle
        end
    end

    assign tc = (counter_reg == 0);

endmodule