module TopModule (
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    reg init_done;

    always @(posedge clk) begin
        if (!init_done) begin
            q <= 4'b0000;
            init_done <= 1'b1;
        end else if (shift_ena) begin
            q <= {q[2:0], data};
        end else if (count_ena) begin
            q <= q - 1;
        end
        // else hold (no else branch needed; reg holds value by default)
    end

endmodule