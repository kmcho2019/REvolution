module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] current_state;

always @(posedge clk) begin
    if (shift_ena) begin
        current_state = {data, current_state[3:1]};
    end else if (count_ena) begin
        current_state = current_state - 1;
    end
end

assign q = current_state;

endmodule