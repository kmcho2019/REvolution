module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    reg [3:0] neighbor_count [0:255];
    integer i, j, idx;

    // Neighbor counting logic
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                idx = i*16 + j;
                // Calculate neighbor positions with wrap-around
                // Using shift instead of multiply for row indexing
                neighbor_count[idx] = 
                    q[((i-1)&15)<<4 | ((j-1)&15)] +  // top-left
                    q[((i-1)&15)<<4 | j] +          // top
                    q[((i-1)&15)<<4 | ((j+1)&15)] +  // top-right
                    q[i<<4 | ((j-1)&15)] +           // left
                    q[i<<4 | ((j+1)&15)] +           // right
                    q[((i+1)&15)<<4 | ((j-1)&15)] +  // bottom-left
                    q[((i+1)&15)<<4 | j] +           // bottom
                    q[((i+1)&15)<<4 | ((j+1)&15)];   // bottom-right
            end
        end
    end

    // Next state calculation
    always @(*) begin
        for (i = 0; i < 256; i = i + 1) begin
            case (neighbor_count[i])
                0, 1: next_q[i] = 1'b0;
                2: next_q[i] = q[i];
                3: next_q[i] = 1'b1;
                default: next_q[i] = 1'b0;
            endcase
        end
    end

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule