module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);
    // 10-bit down counter register
    reg [9:0] counter;
    // Single D flip-flop storing terminal count (counter==0)
    reg tc_reg;

    // Next values combinational logic
    wire [9:0] counter_next;
    wire tc_next;

    assign counter_next = load ? data : (counter != 0 ? counter - 1 : 0);
    assign tc_next = (counter_next == 0);

    always @(posedge clk) begin
        counter <= counter_next;
        tc_reg <= tc_next;
    end

    assign tc = tc_reg;

endmodule