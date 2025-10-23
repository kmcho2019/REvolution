module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;

// Combinational logic to calculate next state
wire [255:0] next_grid;
assign next_grid = calc_next_state(grid);

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

// Module to calculate next state
function [255:0] calc_next_state;
    input [255:0] current_state;
    reg [255:0] next_state;
    integer i, j, x, y;
    reg [3:0] count;
    for (i = 0; i < 256; i++) begin
        count = 0;
        next_state[i] = current_state[i]; // Initialize next_state with current_state
        for (x = -1; x <= 1; x++) begin
            for (y = -1; y <= 1; y++) begin
                if (x == 0 && y == 0) begin
                    // skip current cell
                end else begin
                    j = ((i / 16 + x + 16) % 16) * 16 + (i % 16 + y + 16) % 16;
                    count = count + current_state[j];
                end
            end
        end
        if (current_state[i] == 1'b1) begin
            if (count < 2 || count > 3) begin
                next_state[i] = 1'b0;
            end 
        end else if (count == 3) begin
            next_state[i] = 1'b1;
        end
    end
    return next_state;
endfunction

endmodule