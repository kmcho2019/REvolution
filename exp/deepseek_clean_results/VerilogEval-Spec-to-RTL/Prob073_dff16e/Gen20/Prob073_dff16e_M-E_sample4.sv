module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    // Generate per-bit write enables
    wire [15:0] bit_enable;
    assign bit_enable[15:8] = {8{byteena[1]}};
    assign bit_enable[7:0] = {8{byteena[0]}};

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            // Conditional update for each bit
            for (integer i = 0; i < 16; i = i + 1) begin
                if (bit_enable[i]) begin
                    q[i] <= d[i];
                end
            end
        end
    end

endmodule