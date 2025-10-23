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
reg [1:0] next_state;

// Encoding of states:
// 00: below s[0]
// 01: between s[1] and s[0]
// 10: between s[2] and s[1]
// 11: above s[2]

always @(*) begin
    case (current_state)
        2'b00: next_state = (~s[0] && ~s[1] && ~s[2]) ? 2'b00 : (s[0] && ~s[1] && ~s[2]) ? 2'b01 : 2'b01;
        2'b01: next_state = (s[0] && ~s[1] && ~s[2]) ? 2'b01 : (s[0] && s[1] && ~s[2]) ? 2'b10 : 2'b10;
        2'b10: next_state = (s[0] && s[1] && ~s[2]) ? 2'b10 : (s[0] && s[1] && s[2]) ? 2'b11 : 2'b11;
        2'b11: next_state = (s[0] && s[1] && s[2]) ? 2'b11 : (s[0] && s[1] && ~s[2]) ? 2'b10 : 2'b10;
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= 2'b00;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        2'b00: begin
            fr0 = 1'b1;
            fr1 = 1'b1;
            fr2 = 1'b1;
            dfr = 1'b1;
        end
        2'b01: begin
            fr0 = 1'b1;
            fr1 = 1'b1;
            fr2 = 1'b0;
            dfr = (current_state == 2'b01 && next_state == 2'b01 && s[0] && ~s[1] && ~s[2]) ? 1'b1 : 1'b0;
        end
        2'b10: begin
            fr0 = 1'b1;
            fr1 = 1'b0;
            fr2 = 1'b0;
            dfr = (current_state == 2'b10 && next_state == 2'b10 && s[0] && s[1] && ~s[2]) ? 1'b1 : 1'b0;
        end
        2'b11: begin
            fr0 = 1'b0;
            fr1 = 1'b0;
            fr2 = 1'b0;
            dfr = 1'b0;
        end
    endcase
end

endmodule