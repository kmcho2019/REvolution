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

// State encoding
// 0: All sensors are deasserted (previous water level was low)
// 1: Only sensor s[0] is asserted (previous water level was between s[1] and s[0])
// 2: Sensors s[0] and s[1] are asserted (previous water level was between s[2] and s[1])
// 3: All sensors are asserted (previous water level was above s[2])

always @(*) begin
    case (state)
        0: begin
            if (s[0] == 1'b0 && s[1] == 1'b0 && s[2] == 1'b0) begin
                next_state = 0;
                fr2 = 1'b1;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = 1'b1;
            end else if (s[0] == 1'b1 && s[1] == 1'b0 && s[2] == 1'b0) begin
                next_state = 1;
                fr2 = 1'b0;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = 1'b1;
            end else if (s[0] == 1'b1 && s[1] == 1'b1 && s[2] == 1'b0) begin
                next_state = 2;
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b1;
                dfr = 1'b1;
            end else begin
                next_state = 3;
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b0;
                dfr = 1'b0;
            end
        end
        1: begin
            if (s[0] == 1'b0 && s[1] == 1'b0 && s[2] == 1'b0) begin
                next_state = 0;
                fr2 = 1'b1;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = 1'b1;
            end else if (s[0] == 1'b1 && s[1] == 1'b0 && s[2] == 1'b0) begin
                next_state = 1;
                fr2 = 1'b0;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = 1'b0;
            end else if (s[0] == 1'b1 && s[1] == 1'b1 && s[2] == 1'b0) begin
                next_state = 2;
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b1;
                dfr = 1'b1;
            end else begin
                next_state = 3;
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b0;
                dfr = 1'b0;
            end
        end
        2: begin
            if (s[0] == 1'b0 && s[1] == 1'b0 && s[2] == 1'b0) begin
                next_state = 0;
                fr2 = 1'b1;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = 1'b1;
            end else if (s[0] == 1'b1 && s[1] == 1'b0 && s[2] == 1'b0) begin
                next_state = 1;
                fr2 = 1'b0;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = 1'b0;
            end else if (s[0] == 1'b1 && s[1] == 1'b1 && s[2] == 1'b0) begin
                next_state = 2;
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b1;
                dfr = 1'b0;
            end else begin
                next_state = 3;
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b0;
                dfr = 1'b0;
            end
        end
        3: begin
            if (s[0] == 1'b0 && s[1] == 1'b0 && s[2] == 1'b0) begin
                next_state = 0;
                fr2 = 1'b1;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = 1'b1;
            end else if (s[0] == 1'b1 && s[1] == 1'b0 && s[2] == 1'b0) begin
                next_state = 1;
                fr2 = 1'b0;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = 1'b1;
            end else if (s[0] == 1'b1 && s[1] == 1'b1 && s[2] == 1'b0) begin
                next_state = 2;
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b1;
                dfr = 1'b1;
            end else begin
                next_state = 3;
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b0;
                dfr = 1'b0;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        state <= next_state;
    end
end

endmodule