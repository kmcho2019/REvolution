module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] state;
reg [1:0] prev_state;

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b11;
        prev_state <= 2'b11;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_state <= state;
        case (s)
            3'b111: state <= 2'b00; // above the highest sensor
            3'b110: state <= 2'b01; // between the highest and middle sensors
            3'b100: state <= 2'b10; // between the middle and lowest sensors
            3'b000: state <= 2'b11; // below the lowest sensor
            default: state <= state; // stay in the same state
        endcase
        case (state)
            2'b00: begin // above the highest sensor
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            2'b01: begin // between the highest and middle sensors
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                if (prev_state == 2'b11 || prev_state == 2'b10) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            2'b10: begin // between the middle and lowest sensors
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (prev_state == 2'b11) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            2'b11: begin // below the lowest sensor
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
        endcase
    end
end

endmodule