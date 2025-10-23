module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        reg [511:0] next_state;
        for (int i = 0; i < 512; i++) begin
            wire left, right, state;
            if (i == 0) begin
                left = 1'b0;
            end else begin
                left = current_state[i - 1];
            end
            if (i == 511) begin
                right = 1'b0;
            end else begin
                right = current_state[i + 1];
            end
            state = current_state[i];
            case ({left, state, right})
                3'b111: next_state[i] = 1'b0;
                3'b100: next_state[i] = 1'b0;
                3'b000: next_state[i] = 1'b0;
                default: next_state[i] = 1'b1;
            endcase
        end
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule