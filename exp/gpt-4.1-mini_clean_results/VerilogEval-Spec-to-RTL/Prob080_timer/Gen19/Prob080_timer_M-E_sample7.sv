module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    // Single D flip-flop state: 1 = counting active, 0 = idle (count reached zero)
    reg active;

    // 10-bit counter stored in combinational logic, updated inside clocked block via active signal
    reg [9:0] counter;

    wire [9:0] counter_next;

    // Next value of the counter depends on load and active state
    assign counter_next = load ? data : (active ? (counter - 1) : counter);

    // Terminal count when counter is zero
    assign tc = (counter == 0);

    // On clock edge, update counter and active state
    always @(posedge clk) begin
        // Load counter if load asserted, else decrement if active and not zero
        if (load) begin
            counter <= data;
            active <= (data != 0);
        end else if (active) begin
            if (counter != 0) begin
                counter <= counter - 1;
                active <= (counter != 1); // Will be zero on next cycle if counter==1 now
            end else begin
                active <= 0; // Reached zero, stop counting
            end
        end else begin
            // Remain idle if not active
            active <= 0;
            counter <= counter; // hold count at zero
        end
    end

endmodule