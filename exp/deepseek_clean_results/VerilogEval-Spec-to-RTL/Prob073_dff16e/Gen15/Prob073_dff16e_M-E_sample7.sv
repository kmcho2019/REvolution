module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    // Individual flip-flop enables
    wire [15:0] flip_flop_enable;
    
    // Generate enable signals for each flip-flop
    assign flip_flop_enable[15:8] = {8{byteena[1]}};
    assign flip_flop_enable[7:0] = {8{byteena[0]}};
    
    // Array of 16 flip-flops
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : dff_array
            always @(posedge clk) begin
                if (!resetn) begin
                    q[i] <= 1'b0;
                end else if (flip_flop_enable[i]) begin
                    q[i] <= d[i];
                end
            end
        end
    endgenerate

endmodule