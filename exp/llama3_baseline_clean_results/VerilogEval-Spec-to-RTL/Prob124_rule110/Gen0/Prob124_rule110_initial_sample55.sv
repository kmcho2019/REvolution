module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] state; // current state of the cells

always @(posedge clk) begin
    if (load) begin
        state <= data; // load new data
    end else begin
        reg [511:0] next_state; // next state of the cells
        for (int i = 0; i < 512; i++) begin
            reg left, center, right; // states of the current cell and its neighbors
            if (i == 0) begin
                left = 0; // boundary
            end else begin
                left = state[i - 1];
            end
            center = state[i];
            if (i == 511) begin
                right = 0; // boundary
            end else begin
                right = state[i + 1];
            end
            // apply Rule 110
            case ({left, center, right})
                3'b111: next_state[i] = 0;
                3'b110: next_state[i] = 1;
                3'b101: next_state[i] = 1;
                3'b100: next_state[i] = 0;
                3'b011: next_state[i] = 1;
                3'b010: next_state[i] = 1;
                3'b001: next_state[i] = 1;
                3'b000: next_state[i] = 0;
                default: next_state[i] = 0; // should not reach here
            endcase
        end
        state <= next_state; // update the state
    end
end

assign q = state; // output the current state

endmodule