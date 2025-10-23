module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] state;
reg [2:0] prev_state;

// Encode sensor states into a single state variable
always @(*) begin
    if (~s[2] && ~s[1] && ~s[0]) begin
        state = 3'b000; // Below s[0]
    end else if (~s[2] && ~s[1] && s[0]) begin
        state = 3'b001; // Between s[0] and s[1]
    end else if (~s[2] && s[1] && s[0]) begin
        state = 3'b010; // Between s[1] and s[2]
    end else if (s[2] && s[1] && s[0]) begin
        state = 3'b011; // Above s[2]
    end else begin
        state = 3'b000; // Default state
    end
end

// Determine output signals based on the current state
always @(*) begin
    case (state)
        3'b000: begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
        end
        3'b001: begin
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
        end
        3'b010: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
        end
        3'b011: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
        end
        default: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
        end
    endcase
end

// Determine supplemental flow rate (dfr) signal based on state transition
always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        prev_state <= 3'b000;
        dfr <= 1'b1;
    end else begin
        prev_state <= state;
        if (state > prev_state) begin
            dfr <= 1'b1;
        end else begin
            dfr <= 1'b0;
        end
    end
end

endmodule