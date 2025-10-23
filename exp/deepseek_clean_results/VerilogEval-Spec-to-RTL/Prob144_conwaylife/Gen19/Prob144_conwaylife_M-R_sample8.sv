module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    reg [3:0] neighbor_count [0:255];
    integer i, j, row, col;

    // Combinational neighbor counting and next state calculation
    always @(*) begin
        for (i = 0; i < 256; i = i + 1) begin
            row = i >> 4;  // i / 16 using shift
            col = i & 15;  // i % 16 using mask
            
            // Calculate neighbor positions with toroidal wrapping
            neighbor_count[i] = 
                q[((row-1)&15)<<4 | ((col-1)&15)] +  // top-left
                q[((row-1)&15)<<4 | col] +           // top-center
                q[((row-1)&15)<<4 | ((col+1)&15)] +  // top-right
                q[row<<4 | ((col-1)&15)] +           // left
                q[row<<4 | ((col+1)&15)] +           // right
                q[((row+1)&15)<<4 | ((col-1)&15)] +  // bottom-left
                q[((row+1)&15)<<4 | col] +           // bottom-center
                q[((row+1)&15)<<4 | ((col+1)&15)];    // bottom-right

            // Next state based on neighbor count
            case (neighbor_count[i])
                3: next_q[i] = 1'b1;
                2: next_q[i] = q[i];
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