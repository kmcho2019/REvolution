module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] state;
reg [2:0] nextState;

always @(*) begin
    case(state)
        3'b000: begin  // Below s[0]
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
            if (s[0] == 1'b1) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b000;
            end
        end
        3'b001: begin  // Between s[0] and s[1]
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
            if (s[1] == 1'b1) begin
                dfr = 1'b1;
            end else begin
                dfr = 1'b0;
            end
            if (s[1] == 1'b1) begin
                nextState = 3'b010;
            end else if (s[0] == 1'b0) begin
                nextState = 3'b000;
            end else begin
                nextState = 3'b001;
            end
        end
        3'b010: begin  // Between s[1] and s[2]
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
            if (s[2] == 1'b1) begin
                dfr = 1'b1;
            end else begin
                dfr = 1'b0;
            end
            if (s[2] == 1'b1) begin
                nextState = 3'b011;
            end else if (s[1] == 1'b0) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b010;
            end
        end
        3'b011: begin  // Above s[2]
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
            if (s[2] == 1'b0) begin
                nextState = 3'b010;
            end else begin
                nextState = 3'b011;
            end
        end
        default: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
            nextState = 3'b000;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset == 1'b1) begin
        state <= 3'b000;
    end else begin
        state <= nextState;
    end
end

endmodule