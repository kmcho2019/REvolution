module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] current_state;
reg [1:0] previous_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= 2'b00;
        previous_state <= 2'b00;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        previous_state <= current_state;
        if (s[2] == 1'b1) begin
            current_state <= 2'b11;
        end else if (s[1] == 1'b1) begin
            current_state <= 2'b10;
        end else if (s[0] == 1'b1) begin
            current_state <= 2'b01;
        end else begin
            current_state <= 2'b00;
        end
    end
end

always @(*) begin
    case (current_state)
        2'b00: begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end
        2'b01: begin
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = (previous_state < current_state) ? 1'b1 : 1'b0;
        end
        2'b10: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
            dfr = (previous_state < current_state) ? 1'b1 : 1'b0;
        end
        2'b11: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
        end
        default: begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end
    endcase
end

endmodule