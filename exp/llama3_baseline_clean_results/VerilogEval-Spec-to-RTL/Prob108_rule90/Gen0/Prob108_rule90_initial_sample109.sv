module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= calculate_next_state(q);
    end
end

function [511:0] calculate_next_state;
input [511:0] current_state;
reg [511:0] next_state;
integer i;
begin
    for (i = 0; i < 512; i = i + 1) begin
        reg left, center, right;
        if (i == 0) begin
            left = 1'b0;
            center = current_state[i];
            right = current_state[i + 1];
        end else if (i == 511) begin
            left = current_state[i - 1];
            center = current_state[i];
            right = 1'b0;
        end else begin
            left = current_state[i - 1];
            center = current_state[i];
            right = current_state[i + 1];
        end
        next_state[i] = left ^ right;
    end
    calculate_next_state = next_state;
end
endfunction

assign q = q;

endmodule