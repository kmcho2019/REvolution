module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    reg [3:0] q_next;

    // Combinational logic block to determine the next count value
    always @(*) begin
        case (q)
            4'd9: q_next = 4'd0;
            default: q_next = q + 4'd1;
        endcase
    end

    // Sequential logic with synchronous reset and clock enable
    always @(posedge clk) begin
        if (reset)
            q <= 4'd0;
        else if (slowena)
            q <= q_next;
    end

endmodule