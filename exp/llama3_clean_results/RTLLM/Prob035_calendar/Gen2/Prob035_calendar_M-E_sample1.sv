module calendar(
    input           CLK,    // Clock input
    input           RST,    // Active high reset signal
    output reg [5:0] Hours, // 6-bit output representing the current hours
    output reg [5:0] Mins,  // 6-bit output representing the current minutes
    output reg [5:0] Secs   // 6-bit output representing the current seconds
);

reg [16:0] state; // 17-bit state variable

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 17'd0;
    end else begin
        // Increment seconds
        if (state[5:0] == 6'd59) begin
            state[5:0] <= 6'd0;
            // Increment minutes
            if (state[11:6] == 6'd59) begin
                state[11:6] <= 6'd0;
                // Increment hours
                if (state[16:12] == 5'd23) begin
                    state[16:12] <= 5'd0;
                end else begin
                    state[16:12] <= state[16:12] + 1'd1;
                end
            end else begin
                state[11:6] <= state[11:6] + 1'd1;
            end
        end else begin
            state[5:0] <= state[5:0] + 1'd1;
        end
    end
end

always @(*) begin
    Hours <= state[16:12];
    Mins <= state[11:6];
    Secs <= state[5:0];
end

endmodule