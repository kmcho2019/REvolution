module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;

    // Rule 110 can be expressed as: next_state = right_neighbor ^ (center | left_neighbor)
    // except for the 111 case which is 0 (handled by AND with ~(left & center & right)
    wire [511:0] rule110_logic = (q | {1'b0, q[511:1]}) ^ {q[510:0], 1'b0};
    wire [511:0] all_ones_case = {1'b0, q[511:1]} & q & {q[510:0], 1'b0};

    always @(*) begin
        if (!load) begin
            next_q = rule110_logic & ~all_ones_case;
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule