module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] state;

always_ff @(posedge clk) begin
    if (reset) begin
        // Reset to initial state (below s[0])
        state <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Determine current state based on sensor inputs
        if (s[2]) begin
            // Above s[2]
            state <= 3'b111;
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s[1]) begin
            // Between s[2] and s[1]
            state <= 3'b110;
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            dfr <= 1'b0;
        end else if (s[0]) begin
            // Between s[1] and s[0]
            state <= 3'b100;
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b0;
        end else begin
            // Below s[0]
            state <= 3'b000;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b0;
        end

        // Check previous sensor change to determine if Supplemental flow valve should be opened
        if (state != 3'b111 && (s[0] && (state == 3'b000 || state == 3'b100)) || (s[1] && (state == 3'b000 || state == 3'b100 || state == 3'b110)) || (s[2] && (state == 3'b000 || state == 3'b100 || state == 3'b110 || state == 3'b111))) begin
            dfr <= 1'b1;
        end else begin
            dfr <= 1'b0;
        end
    end
end

endmodule