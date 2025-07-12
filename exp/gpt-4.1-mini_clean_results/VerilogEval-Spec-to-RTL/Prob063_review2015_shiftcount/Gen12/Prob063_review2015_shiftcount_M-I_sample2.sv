module TopModule (
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    reg initialized;

    always @(posedge clk) begin
        if (!initialized) begin
            q <= 4'b0000;
            initialized <= 1'b1;
        end else if (shift_ena) begin
            q <= {q[2:0], data};
        end else if (count_ena) begin
            q <= q - 1;
        end
        // hold q otherwise, no assignment for power saving
    end

endmodule