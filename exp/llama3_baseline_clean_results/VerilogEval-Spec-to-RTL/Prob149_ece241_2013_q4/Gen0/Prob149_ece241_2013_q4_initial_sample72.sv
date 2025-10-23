module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s;

always @(*) begin
    if (s == 3'b000) begin // Below s[0]
        fr0 = 1'b1;
        fr1 = 1'b1;
        fr2 = 1'b1;
        if (prev_s!= 3'b000) begin // Transition to LOW state
            dfr = 1'b1;
        end else begin
            dfr = 1'b1;
        end
    end else if (s == 3'b001) begin // Between s[0] and s[1]
        fr0 = 1'b1;
        fr1 = 1'b1;
        fr2 = 1'b0;
        if (prev_s < s) begin // Transition to LOW_MID state from a lower state
            dfr = 1'b1;
        end else begin
            dfr = 1'b0;
        end
    end else if (s == 3'b011) begin // Between s[1] and s[2]
        fr0 = 1'b1;
        fr1 = 1'b0;
        fr2 = 1'b0;
        if (prev_s < s) begin // Transition to MID_HIGH state from a lower state
            dfr = 1'b1;
        end else begin
            dfr = 1'b0;
        end
    end else if (s == 3'b111) begin // Above s[2]
        fr0 = 1'b0;
        fr1 = 1'b0;
        fr2 = 1'b0;
        if (prev_s < s) begin // Transition to HIGH state from a lower state
            dfr = 1'b0;
        end else begin
            dfr = 1'b0;
        end
    end else begin // Other states
        fr0 = 1'b0;
        fr1 = 1'b0;
        fr2 = 1'b0;
        dfr = 1'b0;
    end
end

always @(posedge clk) begin
    if (reset) begin // Synchronous reset
        fr0 = 1'b1;
        fr1 = 1'b1;
        fr2 = 1'b1;
        dfr = 1'b1;
        prev_s = 3'b000;
    end else begin
        prev_s = s;
    end
end

endmodule