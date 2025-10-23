module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s; // Register to store previous sensor state

// Sequential logic to update previous sensor state and reset logic
always @(posedge clk) begin
    if (reset) begin
        prev_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_s <= s;
        
        // Reset output signals based on sensor states
        if (s == 3'b111) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s == 3'b110) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            dfr <= 1'b0;
        end else if (s == 3'b100) begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b0;
        end else if (s == 3'b000) begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b0;
        end else if (s == 3'b001) begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b0;
        end else if (s == 3'b011) begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= (s[0] > prev_s[0] || (s[1] > prev_s[1] && s[0] == prev_s[0]));
        end else if (s == 3'b101) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            dfr <= (s[1] > prev_s[1] && s[0] == prev_s[0]);
        end
        
        // Check if water level is increasing and set dfr accordingly
        if ((s[0] > prev_s[0]) || (s[1] > prev_s[1] && s[0] == prev_s[0]) || (s[2] > prev_s[2] && s[1] == prev_s[1] && s[0] == prev_s[0])) begin
            if (s!= 3'b000) begin
                dfr <= 1'b1;
            end
        end else begin
            dfr <= 1'b0;
        end
    end
end

endmodule