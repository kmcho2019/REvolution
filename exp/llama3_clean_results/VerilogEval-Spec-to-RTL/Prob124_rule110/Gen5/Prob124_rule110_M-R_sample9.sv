module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

// Extracted Rule 110 logic into a separate function
function next_state_bit;
    input [2:0] neighbor_states;
    begin
        case (neighbor_states)
            3'b111: next_state_bit = 1'b0;
            3'b110: next_state_bit = 1'b1;
            3'b101: next_state_bit = 1'b1;
            3'b100: next_state_bit = 1'b0;
            3'b011: next_state_bit = 1'b1;
            3'b010: next_state_bit = 1'b1;
            3'b001: next_state_bit = 1'b1;
            3'b000: next_state_bit = 1'b0;
        endcase
    end
endfunction

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            reg [2:0] neighbor_states;
            if (i == 0) begin
                neighbor_states = {1'b0, current_state[i], i == 511 ? 1'b0 : current_state[i + 1]};
            end else if (i == 511) begin
                neighbor_states = {current_state[i - 1], current_state[i], 1'b0};
            end else begin
                neighbor_states = {current_state[i - 1], current_state[i], current_state[i + 1]};
            end
            next_state[i] <= next_state_bit(neighbor_states);
        end
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule