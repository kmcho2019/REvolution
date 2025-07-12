module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

    reg fb_bit;  // registered feedback bit

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= 64'b0;
            fb_bit <= 1'b1; // Initialize feedback bit as 1, consistent with first shift-in bit
        end else begin
            Q <= {fb_bit, Q[63:1]};
            fb_bit <= ~Q[0];
        end
    end

endmodule