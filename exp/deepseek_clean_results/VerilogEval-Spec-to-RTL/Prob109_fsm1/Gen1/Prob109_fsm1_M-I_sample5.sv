module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // Define states with clearer names
    reg state;
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    // State transition logic simplified
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_B;
        end else begin
            state <= (state == STATE_A) ? (in ? STATE_A : STATE_B)
                                        : (in ? STATE_B : STATE_A);
        end
    end

    // Registered output to prevent glitches
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= STATE_B; // Output matches reset state
        end else begin
            out <= state;
        end
    end

endmodule