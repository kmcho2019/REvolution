module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    localparam CONST_FOUR = 3'd4;
    localparam MODULO_MAX = 3'd6;

    reg [2:0] q_next;

    // Combinational logic to determine next q value
    always @* begin
        if (a)
            q_next = CONST_FOUR;
        else if (q == MODULO_MAX)
            q_next = 3'd0;
        else
            q_next = q + 3'd1;
    end

    // Sequential logic to update q at clock edge
    always @(posedge clk) begin
        q <= q_next;
    end

endmodule