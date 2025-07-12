module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] count; // internal counter representing states 0..6

// Function for modulo-7 addition: (x + 4) mod 7
function [2:0] map_count_to_q;
    input [2:0] c;
    reg [3:0] sum;
    begin
        sum = c + 4;
        if (sum >= 7)
            map_count_to_q = sum - 7;
        else
            map_count_to_q = sum[2:0];
    end
endfunction

always @(posedge clk) begin
    if (a) begin
        count <= 3'd0; // internal count 0 corresponds to q=4
    end else begin
        if (count == 3'd6)
            count <= 3'd0;
        else
            count <= count + 1;
    end
    q <= map_count_to_q(count);
end

endmodule