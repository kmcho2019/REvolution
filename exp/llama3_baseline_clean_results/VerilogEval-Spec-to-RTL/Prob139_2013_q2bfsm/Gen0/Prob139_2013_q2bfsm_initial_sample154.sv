module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state;
localparam STATE_A = 3'b000;
localparam STATE_B = 3'b001;
localparam STATE_C = 3'b010;
localparam STATE_C1 = 3'b011;  // received first 1 in x sequence
localparam STATE_C0 = 3'b100;  // received second 0 in x sequence
localparam STATE_D = 3'b101;
localparam STATE_D1 = 3'b110;  // first clock cycle after g set to 1
localparam STATE_E = 3'b111;   // g = 1 permanently
localparam STATE_F = 3'b1000;  // g = 0 permanently (not used as we only have 3 bits)

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            STATE_A: begin
                state <= STATE_B;
                f <= 1;
                g <= 0;
            end
            STATE_B: begin
                state <= STATE_C;
                f <= 0;
                g <= 0;
            end
            STATE_C: begin
                if (x) begin
                    state <= STATE_C1;
                end
                g <= 0;
            end
            STATE_C1: begin
                if (!x) begin
                    state <= STATE_C0;
                end else begin
                    state <= STATE_C1;
                end
                g <= 0;
            end
            STATE_C0: begin
                if (x) begin
                    state <= STATE_D;
                    g <= 1;
                end else begin
                    state <= STATE_C;
                end
            end
            STATE_D: begin
                state <= STATE_D1;
            end
            STATE_D1: begin
                if (y) begin
                    state <= STATE_E;
                end else begin
                    state <= STATE_F;
                end
            end
            STATE_E: begin
                // do nothing, stay in this state
            end
            default: begin  // STATE_F
                // do nothing, stay in this state
            end
        endcase
    end
end

always @(*) begin
    case (state)
        STATE_E: g = 1;
        STATE_F: g = 0;
        default: g = (state == STATE_D || state == STATE_D1);
    endcase
end

endmodule