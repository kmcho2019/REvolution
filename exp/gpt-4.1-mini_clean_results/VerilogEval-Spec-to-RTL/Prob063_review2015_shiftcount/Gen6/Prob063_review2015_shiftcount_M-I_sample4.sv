module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    // Initialize q to zero to avoid unknown states at start
    initial begin
        q = 4'b0000;
    end

    // Compute next value if shifting
    wire [3:0] shift_next = {data, q[3:1]};
    // Compute next value if counting down (decrement)
    wire [3:0] count_next = q - 4'd1;

    always @(posedge clk) begin
        if (shift_ena) begin
            q <= shift_next;
        end else if (count_ena) begin
            q <= count_next;
        end
        // else retain q
    end

endmodule