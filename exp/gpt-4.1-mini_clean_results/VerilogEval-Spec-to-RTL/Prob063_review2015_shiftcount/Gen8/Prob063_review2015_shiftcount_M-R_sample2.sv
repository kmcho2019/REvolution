module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    wire [3:0] shift_val;
    wire [3:0] count_val;

    // Next value if shifting
    assign shift_val = {q[2:0], data};
    // Next value if counting down
    assign count_val = q - 1;

    always @(posedge clk) begin
        if (shift_ena) begin
            q <= shift_val;
        end else if (count_ena) begin
            q <= count_val;
        end else begin
            q <= q;
        end
    end

endmodule