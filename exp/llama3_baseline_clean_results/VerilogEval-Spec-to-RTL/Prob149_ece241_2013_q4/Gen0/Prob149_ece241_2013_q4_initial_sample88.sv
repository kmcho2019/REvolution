module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] state;
reg [1:0] nextState;
reg prev_s0, prev_s1, prev_s2;

always @(*) begin
    case({s[2], s[1], s[0]})
        3'b000: begin // Water level below s[0]
            nextState = 2'b00;
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end
        3'b001: begin // Water level between s[1] and s[0]
            nextState = 2'b01;
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = (s[0] == 1'b1 && prev_s0 == 1'b0) ? 1'b1 : 1'b0;
        end
        3'b011: begin // Water level between s[2] and s[1]
            nextState = 2'b10;
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
            dfr = (s[1] == 1'b1 && prev_s1 == 1'b0) ? 1'b1 : 1'b0;
        end
        default: begin // Water level above s[2]
            nextState = 2'b11;
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 2'b00;
        prev_s0 <= 1'b0;
        prev_s1 <= 1'b0;
        prev_s2 <= 1'b0;
    end else begin
        state <= nextState;
        prev_s0 <= s[0];
        prev_s1 <= s[1];
        prev_s2 <= s[2];
    end
end

endmodule