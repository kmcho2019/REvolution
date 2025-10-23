module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to LOW state
    end else begin
        case (s)
            3'b000: next_state <= 2'b00; // Below s[0]
            3'b001: next_state <= 2'b01; // Between s[0] and s[1]
            3'b011: next_state <= 2'b10; // Between s[1] and s[2]
            3'b111: next_state <= 2'b11; // Above s[2]
            default: next_state <= state;
        endcase
    end
    state <= next_state;
end

always @(*) begin
    case (state)
        2'b00: begin // Below s[0]
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
        end
        2'b01: begin // Between s[0] and s[1]
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
        end
        2'b10: begin // Between s[1] and s[2]
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
        end
        2'b11: begin // Above s[2]
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
        end
    endcase
    
    // Determine dfr based on state transition
    if (state == 2'b00 && next_state != 2'b00) begin
        dfr = 1'b1;
    end else begin
        dfr = 1'b0;
    end
end

endmodule