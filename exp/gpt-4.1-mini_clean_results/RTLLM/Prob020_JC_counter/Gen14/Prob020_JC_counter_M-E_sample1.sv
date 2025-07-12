module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

    reg fb;  // Feedback bit (inverted LSB)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q  <= 64'b0;
            fb <= 1'b1;      // Initialize feedback to 1 to start Johnson sequence
        end else begin
            Q  <= {fb, Q[63:1]};
            fb <= ~Q[0];
        end
    end

endmodule