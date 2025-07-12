module TopModule (
    input        clk,
    input        load,
    input  [9:0] data,
    output       tc
);

    reg [9:1] count_upper;  // bits 9 down to 1 (inferred registers)
    reg        count_lsb;   // bit 0, explicit D flip-flop

    wire zero = (count_upper == 9'd0) && (count_lsb == 1'b0);
    assign tc = zero;

    // Compute next counter value
    wire [9:0] current_count = {count_upper, count_lsb};
    wire [9:0] next_count =
        load          ? data :
        (zero)       ? current_count :
                       current_count - 10'd1;

    // Update registers on clock edge
    always @(posedge clk) begin
        count_lsb   <= next_count[0];
        count_upper <= next_count[9:1];
    end

endmodule