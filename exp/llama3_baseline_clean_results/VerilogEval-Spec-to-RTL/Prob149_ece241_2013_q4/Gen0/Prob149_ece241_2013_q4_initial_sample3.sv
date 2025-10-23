module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] state, nextState;

// Define the states
localparam ABOVE = 2'b00;
localparam BETWEEN_2_1 = 2'b01;
localparam BETWEEN_1_0 = 2'b10;
localparam BELOW = 2'b11;

always @(*) begin
    case(state)
        ABOVE: 
            if (~s[2] && ~s[1] && ~s[0]) begin
                nextState = BELOW;
            end else if (~s[2] && ~s[1] && s[0]) begin
                nextState = BETWEEN_1_0;
            end else if (~s[2] && s[1] && s[0]) begin
                nextState = BETWEEN_2_1;
            end else begin
                nextState = ABOVE;
            end

        BETWEEN_2_1: 
            if (~s[2] && ~s[1] && ~s[0]) begin
                nextState = BELOW;
            end else if (~s[2] && ~s[1] && s[0]) begin
                nextState = BETWEEN_1_0;
            end else if (~s[2] && s[1] && s[0]) begin
                nextState = BETWEEN_2_1;
            end else begin
                nextState = ABOVE;
            end

        BETWEEN_1_0: 
            if (~s[2] && ~s[1] && ~s[0]) begin
                nextState = BELOW;
            end else if (~s[2] && ~s[1] && s[0]) begin
                nextState = BETWEEN_1_0;
            end else if (~s[2] && s[1] && s[0]) begin
                nextState = BETWEEN_2_1;
            end else begin
                nextState = ABOVE;
            end

        BELOW: 
            if (~s[2] && ~s[1] && ~s[0]) begin
                nextState = BELOW;
            end else if (~s[2] && ~s[1] && s[0]) begin
                nextState = BETWEEN_1_0;
            end else if (~s[2] && s[1] && s[0]) begin
                nextState = BETWEEN_2_1;
            end else begin
                nextState = ABOVE;
            end

        default: nextState = BELOW;
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= BELOW;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        state <= nextState;
        if (state == ABOVE) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (state == BETWEEN_2_1) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            dfr <= 1'b0;
        end else if (state == BETWEEN_1_0) begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b0;
        end else if (state == BELOW) begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            if ((state == BELOW && nextState == BETWEEN_1_0) || (state == BETWEEN_1_0 && nextState == BETWEEN_2_1) || (state == BELOW && nextState == BETWEEN_2_1)) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end
    end
end

endmodule