module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Determine flow rate based on sensor inputs and previous state
        if (s[2] == 1'b1) begin
            // Above s[2], no flow
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s[1] == 1'b1) begin
            // Between s[2] and s[1], nominal flow rate
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            if (s[1] == 1'b0 && state == 3'b001) begin
                // Level rising, open supplemental flow valve
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s[0] == 1'b1) begin
            // Between s[1] and s[0], increased flow rate
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            if (s[0] == 1'b0 && state == 3'b001) begin
                // Level rising, open supplemental flow valve
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else begin
            // Below s[0], maximum flow rate
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end
    end
end

always @(posedge clk) begin
    if (~reset) begin
        // Update state based on sensor inputs
        if (s[2] == 1'b1) begin
            state <= 3'b111;
        end else if (s[1] == 1'b1) begin
            state <= 3'b011;
        end else if (s[0] == 1'b1) begin
            state <= 3'b001;
        end else begin
            state <= 3'b000;
        end
    end
end

endmodule