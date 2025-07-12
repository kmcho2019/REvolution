module TopModule (
    input        clk,
    input        load,
    input  [9:0] data,
    output       tc
);

    reg [9:0] counter;

    wire counter_nonzero = |counter;
    wire enable = load | counter_nonzero;

    wire [9:0] next_counter = load ? data :
                             (counter_nonzero ? counter - 10'd1 : counter);

    always @(posedge clk) begin
        if (enable) begin
            counter <= next_counter;
        end
        // else hold the counter value (likely zero)
    end

    assign tc = ~(|counter);

endmodule