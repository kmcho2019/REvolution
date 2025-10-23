module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] state;
reg [2:0] prev_state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000;
        prev_state <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        case (s)
            3'b111: state <= 3'b100; // ABOVE_S2
            3'b110: state <= 3'b011; // BETWEEN_S2_S1
            3'b101, 3'b100: state <= 3'b010; // BETWEEN_S1_S0
            default: state <= 3'b001; // BELOW_S0
        endcase

        if (state!= prev_state) begin
            prev_state <= state;
        end

        case (state)
            3'b100: begin // ABOVE_S2
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            3'b011: begin // BETWEEN_S2_S1
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (prev_state == 3'b100);
            end
            3'b010: begin // BETWEEN_S1_S0
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (prev_state == 3'b011) || (prev_state == 3'b100);
            end
            default: begin // BELOW_S0
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
        endcase
    end
end

endmodule