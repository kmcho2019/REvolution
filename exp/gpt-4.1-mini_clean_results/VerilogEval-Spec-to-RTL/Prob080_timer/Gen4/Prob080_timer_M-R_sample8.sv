module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    reg [9:0] next_counter;

    // Combinational logic for next counter value
    always @(*) begin
        if (load) begin
            next_counter = data;
        end else if (counter != 0) begin
            next_counter = counter - 1;
        end else begin
            next_counter = 10'b0;
        end
    end

    // Sequential logic: single 10-bit D flip-flop storing counter
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count output when counter reaches zero
    assign tc = (counter == 10'b0);

endmodule