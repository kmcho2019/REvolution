module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] state, next_state;

// Define the states
localparam STATE BELOW_S0 = 2'b00;
localparam STATE BETWEEN_S0_S1 = 2'b01;
localparam STATE BETWEEN_S1_S2 = 2'b10;
localparam STATE ABOVE_S2 = 2'b11;

always @(*) begin
    case (s)
        3'b000: next_state = BELOW_S0;
        3'b001, 3'b010, 3'b011: next_state = BETWEEN_S0_S1;
        3'b100, 3'b101: next_state = BETWEEN_S1_S2;
        3'b110, 3'b111: next_state = ABOVE_S2;
        default: next_state = BELOW_S0;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= BELOW_S0;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        state <= next_state;
        case (next_state)
            BELOW_S0: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (state == BETWEEN_S0_S1 || state == BETWEEN_S1_S2 || state == ABOVE_S2) begin
                    dfr <= 1'b0;
                end else begin
                    dfr <= 1'b1;
                end
            end
            BETWEEN_S0_S1: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (state == BELOW_S0) begin
                    dfr <= 1'b1;
                end else if (state == BETWEEN_S1_S2 || state == ABOVE_S2) begin
                    dfr <= 1'b0;
                end else begin
                    dfr <= 1'b0;
                end
            end
            BETWEEN_S1_S2: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                if (state == BETWEEN_S0_S1 || state == BELOW_S0) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            ABOVE_S2: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
    end
end

endmodule