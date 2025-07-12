module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

enum logic [1:0] {
    below_s0,
    between_s0_s1,
    between_s1_s2,
    above_s2
} current_state, next_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= below_s0;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        case (s)
            3'b000: next_state = below_s0;
            3'b001: next_state = between_s0_s1;
            3'b010, 3'b011: next_state = between_s1_s2;
            3'b100, 3'b101, 3'b110, 3'b111: next_state = above_s2;
        endcase
        current_state <= next_state;

        case (current_state)
            below_s0: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
            between_s0_s1: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (next_state > current_state) ? 1'b1 : 1'b0;
            end
            between_s1_s2: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (next_state > current_state) ? 1'b1 : 1'b0;
            end
            above_s2: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
    end
end

endmodule