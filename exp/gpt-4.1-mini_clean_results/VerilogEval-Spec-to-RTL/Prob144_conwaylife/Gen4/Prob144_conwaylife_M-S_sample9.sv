module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    integer r, c;
    integer ru, rd, cl, cr;
    integer neighbors;
    reg curr_cell;
    reg [255:0] next_state;

    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            ru = (r + 15) & 4'hF;  // row above
            rd = (r + 1)  & 4'hF;  // row below
            for (c = 0; c < 16; c = c + 1) begin
                cl = (c + 15) & 4'hF;  // col left
                cr = (c + 1)  & 4'hF;  // col right

                neighbors = 
                    q[ru*16+cl] + q[ru*16+c] + q[ru*16+cr] +
                    q[r*16+cl]               + q[r*16+cr] +
                    q[rd*16+cl] + q[rd*16+c] + q[rd*16+cr];

                curr_cell = q[r*16 + c];

                if (neighbors <= 1)
                    next_state[r*16 + c] = 1'b0;
                else if (neighbors == 2)
                    next_state[r*16 + c] = curr_cell;
                else if (neighbors == 3)
                    next_state[r*16 + c] = 1'b1;
                else
                    next_state[r*16 + c] = 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule