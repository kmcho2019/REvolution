module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    reg [3:0] next_q;

    always @* begin
        if (shift_ena)
            next_q = {q[2:0], data};
        else if (count_ena)
            next_q = q - 1;
        else
            next_q = q;
    end

    always @(posedge clk) begin
        if (shift_ena || count_ena)
            q <= next_q;
        // else retain q (no change), avoiding unnecessary toggling
    end

endmodule