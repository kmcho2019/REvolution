module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] state;
reg [1:0] reset_counter;

always @(posedge clk) begin
    if (!resetn) begin
        reset_counter <= reset_counter + 1;
        if (reset_counter == 2'd3) begin
            state <= 4'd0;
            reset_counter <= 2'd0;
        end
    end else begin
        state <= {state[2:0], in};
    end
end

assign out = state[3];

endmodule