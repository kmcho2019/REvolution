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
reg [1:0] prevState;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        prevState <= 0;
        fr2 <= 1;
        fr1 <= 1;
        fr0 <= 1;
        dfr <= 1;
    end else begin
        // Determine the next state based on the current sensor inputs
        case (1'b1)
            s[2]: state <= 3;
            s[1]: state <= 2;
            s[0]: state <= 1;
            default: state <= 0;
        endcase

        // Determine the output flow rates based on the current state and previous state
        case (state)
            0: begin
                fr2 <= 1;
                fr1 <= 1;
                fr0 <= 1;
                if (prevState > state) begin
                    dfr <= 0;
                end else begin
                    dfr <= 1;
                end
            end
            1: begin
                fr2 <= 0;
                fr1 <= 1;
                fr0 <= 1;
                if (prevState < state) begin
                    dfr <= 1;
                end else begin
                    dfr <= 0;
                end
            end
            2: begin
                fr2 <= 0;
                fr1 <= 0;
                fr0 <= 1;
                if (prevState < state) begin
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

        prevState <= state;
    end
end

endmodule