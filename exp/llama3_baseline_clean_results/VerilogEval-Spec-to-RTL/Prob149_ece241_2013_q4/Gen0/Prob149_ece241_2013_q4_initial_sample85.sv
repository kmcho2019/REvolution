module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [1:0] state;
reg [1:0] prev_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        prev_state <= 0;
        fr2 <= 1;
        fr1 <= 1;
        fr0 <= 1;
        dfr <= 1;
    end else begin
        prev_state <= state;
        case (s)
            3'b000: state <= 0;
            3'b001: state <= 0;
            3'b010: state <= 0;
            3'b011: state <= 1;
            3'b100: state <= 1;
            3'b101: state <= 1;
            3'b110: state <= 2;
            3'b111: state <= 3;
        endcase

        case (state)
            0: begin
                fr2 <= 1;
                fr1 <= 1;
                fr0 <= 1;
                if (prev_state < state) begin
                    dfr <= 1;
                end else begin
                    dfr <= 0;
                end
            end
            1: begin
                fr2 <= 0;
                fr1 <= 1;
                fr0 <= 1;
                if (prev_state < state) begin
                    dfr <= 1;
                end else begin
                    dfr <= 0;
                end
            end
            2: begin
                fr2 <= 0;
                fr1 <= 0;
                fr0 <= 1;
                if (prev_state < state) begin
                    dfr <= 1;
                end else begin
                    dfr <= 0;
                end
            end
            3: begin
                fr2 <= 0;
                fr1 <= 0;
                fr0 <= 0;
                dfr <= 0;
            end
        endcase
    end
end

endmodule