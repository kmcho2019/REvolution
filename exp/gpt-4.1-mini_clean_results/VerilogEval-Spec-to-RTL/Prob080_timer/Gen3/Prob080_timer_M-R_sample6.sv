module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    reg [9:0] next_counter;

    // Combinational logic to determine next counter value
    always @* begin
        if (load) begin
            next_counter = data;            // Load new timer value
        end else if (|counter) begin
            next_counter = counter - 10'd1; // Decrement if not zero
        end else begin
            next_counter = counter;        // Hold zero if zero
        end
    end

    // Sequential logic: update counter on clock edge
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count asserted when counter is zero
    assign tc = ~|counter;

endmodule