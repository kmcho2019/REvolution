module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] left_neighbors;
    reg compute_phase;  // 0=load/capture, 1=compute
    
    // Stage 1: Capture left neighbors (with boundary)
    wire [511:0] captured_left = {1'b0, q[511:1]};
    
    // Stage 2: XOR with right neighbors (with boundary)
    wire [511:0] right_neighbors = {q[510:0], 1'b0};
    wire [511:0] next_q = left_neighbors ^ right_neighbors;
    
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            compute_phase <= 1'b0;
        end else begin
            if (compute_phase) begin
                q <= next_q;
                compute_phase <= 1'b0;
            end else begin
                left_neighbors <= captured_left;
                compute_phase <= 1'b1;
            end
        end
    end

endmodule