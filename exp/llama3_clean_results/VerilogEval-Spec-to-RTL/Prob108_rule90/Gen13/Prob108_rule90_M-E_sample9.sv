module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to store the current state
reg [511:0] pipe_reg [3:0]; // Pipelined registers

// Load data into q_reg
always @(posedge clk) begin
    if (load) begin
        q_reg <= data; // Load input data
    end else begin
        q_reg <= pipe_reg[3]; // Update with pipelined output
    end
end

// Pipeline stage 1: Calculate next state for cells 0-127
always @(posedge clk) begin
    for (int i = 0; i < 128; i++) begin
        reg left, right;
        if (i == 0) begin
            left = 1'b0; // Left boundary
            right = q_reg[i + 1];
        end else if (i == 127) begin
            left = q_reg[i - 1];
            right = q_reg[i + 1];
        end else begin
            left = q_reg[i - 1];
            right = q_reg[i + 1];
        end
        pipe_reg[0][i] <= left ^ right; // Rule 90: XOR of left and right
    end
end

// Pipeline stage 2: Calculate next state for cells 128-255
always @(posedge clk) begin
    for (int i = 128; i < 256; i++) begin
        reg left, right;
        if (i == 128) begin
            left = pipe_reg[0][i - 1];
            right = q_reg[i + 1];
        end else if (i == 255) begin
            left = pipe_reg[0][i - 1];
            right = 1'b0; // Right boundary
        end else begin
            left = pipe_reg[0][i - 1];
            right = q_reg[i + 1];
        end
        pipe_reg[1][i] <= left ^ right; // Rule 90: XOR of left and right
    end
end

// Pipeline stage 3: Calculate next state for cells 256-383
always @(posedge clk) begin
    for (int i = 256; i < 384; i++) begin
        reg left, right;
        if (i == 256) begin
            left = pipe_reg[1][i - 1];
            right = q_reg[i + 1];
        end else if (i == 383) begin
            left = pipe_reg[1][i - 1];
            right = q_reg[i + 1];
        end else begin
            left = pipe_reg[1][i - 1];
            right = q_reg[i + 1];
        end
        pipe_reg[2][i] <= left ^ right; // Rule 90: XOR of left and right
    end
end

// Pipeline stage 4: Calculate next state for cells 384-511
always @(posedge clk) begin
    for (int i = 384; i < 512; i++) begin
        reg left, right;
        if (i == 384) begin
            left = pipe_reg[2][i - 1];
            right = q_reg[i + 1];
        end else if (i == 511) begin
            left = pipe_reg[2][i - 1];
            right = 1'b0; // Right boundary
        end else begin
            left = pipe_reg[2][i - 1];
            right = q_reg[i + 1];
        end
        pipe_reg[3][i] <= left ^ right; // Rule 90: XOR of left and right
    end
end

assign q = q_reg; // Output the current state

endmodule