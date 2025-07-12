module TopModule (
    input         clk,
    input         resetn,     // Active low asynchronous reset
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            q <= 4'b0000;
        end else if (shift_ena) begin
            q <= {q[2:0], data};
        end else if (count_ena) begin
            q <= q - 1;
        end
        // else hold
    end

endmodule