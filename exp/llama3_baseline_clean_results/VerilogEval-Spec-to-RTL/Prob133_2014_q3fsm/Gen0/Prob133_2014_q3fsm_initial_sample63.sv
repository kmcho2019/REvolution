module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state = 0; // State A (0) and State B (1, 2, 3) can be encoded in 2 bits, but we'll use only 0 and 1 for simplicity
reg [1:0] counter = 0; // Counter for the 3 cycles
reg [1:0] w_count = 0; // Count of w = 1 in 3 cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        counter <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1;
                    counter <= 1;
                    w_count <= w;
                end
            end
            1: begin // State B, examining w
                counter <= counter + 1;
                w_count <= w_count + (w ? 1 : 0);
                if (counter == 3) begin
                    // Set z based on w_count
                    z <= (w_count == 2) ? 1 : 0;
                    counter <= 1; // Reset counter for next 3 cycles
                    w_count <= w; // Reset w_count for next 3 cycles
                end
            end
        endcase
    end
end

endmodule