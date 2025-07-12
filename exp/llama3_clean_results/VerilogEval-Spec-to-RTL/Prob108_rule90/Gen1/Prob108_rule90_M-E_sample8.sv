module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Combinational logic block to compute the next state of each cell
function [511:0] compute_next_state;
    input [511:0] current_state;
    reg [511:0] next_state;

    for (int i = 0; i < 512; i++) begin
        if (i == 0) begin
            next_state[i] = current_state[0] ^ current_state[1];
        end else if (i == 511) begin
            next_state[i] = current_state[510] ^ current_state[511];
        end else begin
            next_state[i] = current_state[i - 1] ^ current_state[i + 1];
        end
    end

    compute_next_state = next_state;
endfunction

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= compute_next_state(q_reg);
    end
end

assign q = q_reg;

endmodule