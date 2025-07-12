module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

// Instantiate 16 BlockWrappers
wire [15:0] block_outputs[15:0];
integer i;
for (i = 0; i < 16; i = i + 1) begin
    BlockWrapper block_wrapper(
        .current_state(current_state),
        .block_index(i),
        .output(block_outputs[i])
    );
end

// Combine block outputs to obtain next state
always @(*) begin
    next_state = 256'b0;
    for (i = 0; i < 16; i = i + 1) begin
        next_state[(i+1)*16-1:i*16] = block_outputs[i];
    end
end

assign q = current_state;

endmodule

module BlockWrapper(
    input [255:0] current_state,
    input [3:0] block_index,
    output reg [15:0] output
);

reg [3:0] row, col;
reg [15:0] block_input;
reg [15:0] block_output;

// Extract 4x4 block from current state
always @(*) begin
    row = block_index / 4;
    col = block_index % 4;
    block_input = 16'b0;
    for (integer i = 0; i < 16; i = i + 1) begin
        block_input[i] = current_state[(row*4 + i/4)*16 + col*4 + i%4];
    end
end

// Process block
BlockProcessor block_processor(
    .input(block_input),
    .output(block_output)
);

assign output = block_output;

endmodule

module BlockProcessor(
    input [15:0] input,
    output reg [15:0] output
);

reg [3:0] alive_neighbors;
reg [3:0] i, x, y;
reg [15:0] output_temp;

always @(*) begin
    output = 16'b0;
    for (i = 0; i < 16; i = i + 1) begin
        alive_neighbors = 0;
        for (x = -1; x <= 1; x = x + 1) begin
            for (y = -1; y <= 1; y = y + 1) begin
                if (x != 0 || y != 0) begin
                    row = (i / 4) + x;
                    col = (i % 4) + y;
                    row = row < 0 ? 3 : row > 3 ? 0 : row;
                    col = col < 0 ? 3 : col > 3 ? 0 : col;
                    if (input[row*4 + col]) begin
                        alive_neighbors = alive_neighbors + 1;
                    end
                end
            end
        end
        if ((alive_neighbors == 3) || (alive_neighbors == 2 && input[i])) begin
            output_temp[i] = 1'b1;
        end 
    end
    output = output_temp;
end

endmodule