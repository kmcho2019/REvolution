module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;

    wire [9:0] next_counter;
    reg borrow;

    integer i;

    // Combinational logic to compute next_counter with ripple borrow decrement
    always @(*) begin
        borrow = 1'b1;  // start with borrow = 1 to implement decrement by 1
        for (i = 0; i < 10; i = i + 1) begin
            if (load) begin
                next_counter[i] = data[i];
            end else if (counter != 0) begin
                // bit decrement with borrow: next_bit = bit ^ borrow, borrow = borrow & ~bit
                next_counter[i] = counter[i] ^ borrow;
                borrow = borrow & (~counter[i]);
            end else begin
                next_counter[i] = 1'b0; // hold zero after terminal count
            end
        end
    end

    // Sequential logic: update counter on posedge clk
    always @(posedge clk) begin
        counter <= next_counter;
    end

    assign tc = (counter == 10'b0);

endmodule