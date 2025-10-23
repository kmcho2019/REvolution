module TopModule (
    input        clk,
    input        rst,        // synchronous active-high reset added for deterministic initialization
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (rst) begin
            q <= 4'b0000;
        end else if (shift_ena) begin
            // Shift right by 1, insert data at MSB
            q <= {data, q[3:1]};
        end else if (count_ena) begin
            // Decrement q (4-bit down counter with natural wrap-around)
            q <= q - 1'b1;
        end
        // else retain q
    end

endmodule