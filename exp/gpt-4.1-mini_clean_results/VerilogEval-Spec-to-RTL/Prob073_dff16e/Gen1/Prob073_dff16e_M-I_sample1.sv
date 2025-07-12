module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            // Create mask based on byte enables: upper byteena[1], lower byteena[0]
            // byteena[1] controls bits 15:8, byteena[0] controls bits 7:0
            // mask bits set to 1 where byteena bit is 1, else 0
            q <= (q & ~{{8{byteena[1]}}, {8{byteena[0]}}}) | (d & {{8{byteena[1]}}, {8{byteena[0]}}});
        end
    end

endmodule