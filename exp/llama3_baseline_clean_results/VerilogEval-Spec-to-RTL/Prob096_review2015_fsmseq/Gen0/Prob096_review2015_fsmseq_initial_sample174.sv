module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] current_state = 4'b0000;

always @(posedge clk) begin
    if (reset) begin
        start_shifting <= 0;
        current_state <= 4'b0000;
    end else begin
        current_state <= {current_state[2:0], data};
        if (current_state == 4'b1101) begin
            start_shifting <= 1;
        end
    end
end

endmodule