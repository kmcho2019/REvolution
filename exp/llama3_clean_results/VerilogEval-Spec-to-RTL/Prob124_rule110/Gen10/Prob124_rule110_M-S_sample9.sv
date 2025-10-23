module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            logic left, center, right;
            left = (i == 0) ? 1'b0 : current_state[i - 1];
            center = current_state[i];
            right = (i == 511) ? 1'b0 : current_state[i + 1];
            case ({left, center, right})
                3'b111, 3'b000, 3'b100, 3'b001: next_state[i] <= 1'b0;
                default: next_state[i] <= 1'b1;
            endcase
        end
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule