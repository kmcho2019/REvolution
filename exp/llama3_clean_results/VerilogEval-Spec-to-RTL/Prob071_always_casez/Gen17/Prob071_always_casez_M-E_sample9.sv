module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    wire [1:0] level1_out;
    wire [1:0] level2_out;

    // Level 1: Compare pairs of bits
    assign level1_out[0] = (in[0] || in[1]) ? (in[0] ? 1'd0 : 1'd1) : 1'd0;
    assign level1_out[1] = (in[2] || in[3]) ? (in[2] ? 1'd0 : 1'd1) : 1'd0;
    assign level2_out[0] = (in[4] || in[5]) ? (in[4] ? 1'd0 : 1'd1) : 1'd0;
    assign level2_out[1] = (in[6] || in[7]) ? (in[6] ? 1'd0 : 1'd1) : 1'd0;

    // Level 2: Determine quadrant
    wire [1:0] quadrant;
    assign quadrant[0] = (level1_out[0] != 0) ? level1_out[0] : level2_out[0];
    assign quadrant[1] = (level1_out[1] != 0) ? level1_out[1] : level2_out[1];

    // Level 3: Determine exact position
    always @(in, quadrant) begin
        if (quadrant[0] == 1'd0 && in[0]) begin
            pos = 3'd0;
        end else if (quadrant[0] == 1'd1 && in[1]) begin
            pos = 3'd1;
        end else if (quadrant[1] == 1'd0 && in[2]) begin
            pos = 3'd2;
        end else if (quadrant[1] == 1'd1 && in[3]) begin
            pos = 3'd3;
        end else if (quadrant[0] == 1'd0 && in[4]) begin
            pos = 3'd4;
        end else if (quadrant[0] == 1'd1 && in[5]) begin
            pos = 3'd5;
        end else if (quadrant[1] == 1'd0 && in[6]) begin
            pos = 3'd6;
        end else if (quadrant[1] == 1'd1 && in[7]) begin
            pos = 3'd7;
        end else begin
            pos = 3'd0; // Default if no '1' is found
        end
    end

endmodule