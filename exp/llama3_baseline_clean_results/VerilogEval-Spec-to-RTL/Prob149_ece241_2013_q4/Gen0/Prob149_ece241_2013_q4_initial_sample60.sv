module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [1:0] current_state;
reg [1:0] previous_state;

always @ (posedge clk) begin
    if (reset) begin
        current_state <= 2'b00;
        previous_state <= 2'b00;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        case (s)
            3'b000: begin
                current_state <= 2'b00;
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
            3'b001: begin
                current_state <= 2'b01;
                if (previous_state == 2'b00) begin
                    dfr <= 1'b0;
                end else begin
                    dfr <= 1'b1;
                end
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            3'b011: begin
                current_state <= 2'b10;
                if (previous_state == 2'b01) begin
                    dfr <= 1'b0;
                end else begin
                    dfr <= 1'b1;
                end
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
            end
            3'b111: begin
                current_state <= 2'b11;
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            default: begin
                current_state <= current_state;
                fr2 <= fr2;
                fr1 <= fr1;
                fr0 <= fr0;
                dfr <= dfr;
            end
        endcase
        previous_state <= current_state;
    end
end

endmodule