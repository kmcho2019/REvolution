module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipelined computation registers
    reg [255:0] stage1_q;
    reg [511:0] next_q;
    
    // Clock gating control
    reg [2:0] idle_counter;
    wire computation_enable = (idle_counter < 3'b100) | load;
    
    // Boundary-aware neighbor computation
    wire [511:0] left_neighbors = {1'b0, q[511:1]};
    wire [511:0] right_neighbors = {q[510:0], 1'b0};
    
    // First pipeline stage (bits 0-255)
    always @(posedge clk) begin
        if (computation_enable) begin
            stage1_q <= left_neighbors[255:0] ^ right_neighbors[255:0];
        end
    end
    
    // Second pipeline stage (bits 256-511)
    always @(posedge clk) begin
        if (computation_enable) begin
            next_q[511:256] <= left_neighbors[511:256] ^ right_neighbors[511:256];
            next_q[255:0] <= stage1_q;
        end
    end
    
    // Idle detection and state update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            idle_counter <= 0;
        end else begin
            q <= next_q;
            idle_counter <= idle_counter + 1;
        end
    end

endmodule