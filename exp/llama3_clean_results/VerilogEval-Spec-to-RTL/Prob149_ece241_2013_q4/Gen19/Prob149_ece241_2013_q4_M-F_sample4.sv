module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define states using enum
enum logic [1:0] {
    BELOW = 2'b00,
    BETWEEN_LOW_MID = 2'b01,
    BETWEEN_MID_HIGH = 2'b10,
    ABOVE = 2'b11
} current_state, next_state, prev_state;

// Combinational logic to determine next state
always @(*) begin
    case (current_state)
        BELOW: begin
            if (s[0]) begin
                next_state = BETWEEN_LOW_MID;
            end else begin
                next_state = BELOW;
            end
        end
        BETWEEN_LOW_MID: begin
            if (s[1]) begin
                next_state = BETWEEN_MID_HIGH;
            end else if (!s[0]) begin
                next_state = BELOW;
            end else begin
                next_state = BETWEEN_LOW_MID;
            end
        end
        BETWEEN_MID_HIGH: begin
            if (s[2]) begin
                next_state = ABOVE;
            end else if (!s[1]) begin
                next_state = BETWEEN_LOW_MID;
            end else begin
                next_state = BETWEEN_MID_HIGH;
            end
        end
        ABOVE: begin
            if (!s[2]) begin
                next_state = BETWEEN_MID_HIGH;
            end else begin
                next_state = ABOVE;
            end
        end
        default: next_state = BELOW;
    endcase
end

// Sequential logic to update current state and reset logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= BELOW;
        prev_state <= BELOW;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_state <= current_state;
        current_state <= next_state;
        
        // Determine output signals based on current state
        case (current_state)
            BELOW: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (prev_state == BELOW) begin
                    dfr <= 1'b0;
                end else begin
                    dfr <= 1'b1;
                end
            end
            BETWEEN_LOW_MID: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (prev_state == BELOW) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            BETWEEN_MID_HIGH: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                if (prev_state == BETWEEN_LOW_MID) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            ABOVE: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            default: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
    end
end

endmodule