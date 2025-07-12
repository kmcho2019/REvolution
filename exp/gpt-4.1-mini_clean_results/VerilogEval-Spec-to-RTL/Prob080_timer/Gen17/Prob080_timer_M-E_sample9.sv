module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;

    // Detect if counter is zero
    wire is_zero = (counter == 10'd0);

    // Decrement by 1 using bitwise operations if not zero
    // Simple decrement can be implemented as: counter - 1 = counter + (~0)
    // but here we implement counter-1 only if counter !=0; else stays zero.
    wire [9:0] dec_counter = counter + 10'b1111111111; // counter - 1

    // Compute next counter state: load data if load=1; else decrement if not zero; else remain zero
    wire [9:0] next_counter = load ? data : (is_zero ? 10'd0 : dec_counter);

    // Sequential update of counter on positive clock edge
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count output is high when counter is zero
    assign tc = is_zero;

endmodule