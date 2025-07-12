module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    reg [9:0] next_counter;
    wire counter_en;

    // Compute the next counter value
    always @(*) begin
        if (load) begin
            next_counter = data;
        end else if (counter != 0) begin
            next_counter = counter - 10'd1;
        end else begin
            next_counter = counter; // hold zero
        end
    end

    // Enable signal: update counter only when loading or counting down
    assign counter_en = load | (counter != 0);

    // Update counter register on clock edge only if enabled
    always @(posedge clk) begin
        if (counter_en) begin
            counter <= next_counter;
        end
    end

    // Terminal count output asserted when counter is zero
    assign tc = (counter == 10'd0);

endmodule