module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Combinational function to compute next count modulo 10
    function [3:0] next_count;
        input [3:0] current;
        begin
            if (current == 4'd9)
                next_count = 4'd0;
            else
                next_count = current + 4'd1;
        end
    endfunction

    wire [3:0] q_next = next_count(q);

    always @(posedge clk) begin
        if (reset)
            q <= 4'd0;
        else
            q <= q_next;
    end

endmodule