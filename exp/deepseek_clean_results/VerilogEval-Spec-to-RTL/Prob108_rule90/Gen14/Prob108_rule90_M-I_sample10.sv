module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    parameter WIDTH = 512;
    parameter SEGMENTS = 4;
    parameter SEG_WIDTH = WIDTH/SEGMENTS;
    
    reg [WIDTH-1:0] q_pipe [SEGMENTS-1:0];
    wire [WIDTH-1:0] next_q;
    reg valid;

    // Clock gating control
    always @(posedge clk) begin
        valid <= load || (valid && !load);  // Stay valid after load until next load
    end

    // Generate XOR for each bit with boundary conditions
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin: rule90
            wire left = (i == 0) ? 1'b0 : q[i-1];
            wire right = (i == WIDTH-1) ? 1'b0 : q[i+1];
            assign next_q[i] = left ^ right;
        end
    endgenerate

    // Pipelined sequential logic
    integer s;
    always @(posedge clk) begin
        if (load) begin
            q_pipe[0] <= data;
            for (s = 1; s < SEGMENTS; s = s + 1)
                q_pipe[s] <= q_pipe[s-1];
        end 
        else if (valid) begin
            q_pipe[0] <= next_q;
            for (s = 1; s < SEGMENTS; s = s + 1)
                q_pipe[s] <= q_pipe[s-1];
        end
    end

    // Output is last pipeline stage
    always @(posedge clk) begin
        q <= q_pipe[SEGMENTS-1];
    end

endmodule