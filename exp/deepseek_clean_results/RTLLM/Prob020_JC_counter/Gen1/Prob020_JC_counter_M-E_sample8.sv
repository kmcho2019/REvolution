module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] up_pattern = 64'h8000_0000_0000_0000;  // MSB=1, others=0
reg [63:0] down_pattern = 64'h7FFF_FFFF_FFFF_FFFF; // MSB=0, others=1
reg [6:0] shift_count;  // Tracks current shift amount (0-63)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        shift_count <= 7'b0;
    end else begin
        if (Q[0] == 1'b0) begin
            // Counting up: right shift the up pattern
            Q <= (up_pattern >> shift_count) | (up_pattern << (64 - shift_count));
            shift_count <= shift_count + 1;
            if (shift_count == 63) shift_count <= 0;
        end else begin
            // Counting down: left shift the down pattern
            Q <= (down_pattern << shift_count) | (down_pattern >> (64 - shift_count));
            shift_count <= shift_count + 1;
            if (shift_count == 63) shift_count <= 0;
        end
    end
end

endmodule