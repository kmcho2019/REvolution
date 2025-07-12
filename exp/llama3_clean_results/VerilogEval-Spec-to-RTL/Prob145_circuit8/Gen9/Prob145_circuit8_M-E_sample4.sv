module TopModule(
    input clock,
    input a,
    output reg p = 0,
    output reg q = 0
);

reg [1:0] state = 0; // 00: p=0, q=0; 01: p=0, q=1; 10: p=1, q=0; 11: p=1, q=1

always @(posedge clock or negedge clock) begin
    if (clock) begin // On positive edge of clock
        if (a) begin
            p <= 1;
            state <= 2; // Set p to 1 and remember that p was high
        end else begin
            p <= 0;
            if (state[1]) begin // If p was previously high
                state <= 1; // Keep q high
            end else begin
                state <= 0; // Reset state
            end
        end
    end else begin // On negative edge of clock
        if (a) begin
            q <= 0; // Reset q if a is high on low clock phase
            state <= 0;
        end else if (state[1]) begin // If p was high on previous high clock phase
            q <= 1; // Set q high
        end
    end
    q <= state[1]; // Update q based on state
end

endmodule