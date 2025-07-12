module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;

// Module to calculate next state
module calc_next_state(
    input [255:0] current_state,
    output reg [255:0] next_state
);

always_comb begin
    for (int i = 0; i < 256; i++) begin
        reg [3:0] count;
        count = 
            (current_state[((i / 16) + 15) % 16 * 16 + ((i % 16) + 1) % 16]) +
            (current_state[((i / 16) + 15) % 16 * 16 + ((i % 16) - 1 + 16) % 16]) +
            (current_state[((i / 16) + 1) % 16 * 16 + ((i % 16) + 1) % 16]) +
            (current_state[((i / 16) + 1) % 16 * 16 + ((i % 16) - 1 + 16) % 16]) +
            (current_state[((i / 16) + 1) % 16 * 16 + (i % 16)]) +
            (current_state[((i / 16) - 1 + 16) % 16 * 16 + ((i % 16) + 1) % 16]) +
            (current_state[((i / 16) - 1 + 16) % 16 * 16 + ((i % 16) - 1 + 16) % 16]) +
            (current_state[((i / 16) - 1 + 16) % 16 * 16 + (i % 16)]);
        if (count <= 1 || count >= 4) begin
            next_state[i] = 1'b0;
        end else if (count == 3) begin
            next_state[i] = 1'b1;
        end else begin
            next_state[i] = current_state[i];
        end
    end
end

endmodule

// Combinational logic to calculate next state
wire [255:0] next_grid;
calc_next_state u_calc_next_state(
    .current_state(grid),
    .next_state(next_grid)
);

// Sequential logic to update current state
always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        grid <= next_grid;
    end
end

// Output current state
assign q = grid;

endmodule