module TopModule(
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    reg init_done;
    reg [3:0] q_next;

    // Combinational next state logic
    always @(*) begin
        if (shift_ena) begin
            // Shift left MSB first: bring in data at LSB side
            q_next = {q[2:0], data};
        end else if (count_ena) begin
            // Decrement q by 1 mod 16
            q_next = q - 1;
        end else begin
            // Hold current state
            q_next = q;
        end
    end

    // Sequential update with synchronous initialization
    always @(posedge clk) begin
        if (!init_done) begin
            q <= 4'b0000;
            init_done <= 1'b1;
        end else begin
            q <= q_next;
        end
    end

endmodule