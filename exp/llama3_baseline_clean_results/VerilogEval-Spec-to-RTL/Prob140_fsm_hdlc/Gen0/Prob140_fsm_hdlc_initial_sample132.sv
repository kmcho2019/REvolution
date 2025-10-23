module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

    reg [2:0] state;
    reg [2:0] nextState;

    always @(*) begin
        case (state)
            3'b000: begin  // State 0
                if (in) begin
                    nextState = 3'b001;  // State 1
                    disc = 1'b0;
                    flag = 1'b0;
                    err = 1'b0;
                end
                else begin
                    nextState = 3'b000;
                    disc = 1'b0;
                    flag = 1'b0;
                    err = 1'b0;
                end
            end
            3'b001: begin  // State 1
                if (in) begin
                    nextState = 3'b010;
                    disc = 1'b0;
                    flag = 1'b0;
                    err = 1'b0;
                end
                else begin
                    nextState = 3'b000;
                    disc = 1'b0;
                    flag = 1'b0;
                    err = 1'b0;
                end
            end
            3'b010: begin  // State 2
                if (in) begin
                    nextState = 3'b011;
                    disc = 1'b0;
                    flag = 1'b0;
                    err = 1'b0;
                end
                else begin
                    nextState = 3'b000;
                    disc = 1'b0;
                    flag = 1'b0;
                    err = 1'b0;
                end
            end
            3'b011: begin  // State 3
                if (in) begin
                    nextState = 3'b100;
                    disc = 1'b0;
                    flag = 1'b0;
                    err = 1'b0;
                end
                else begin
                    nextState = 3'b000;
                    disc = 1'b0;
                    flag = 1'b0;
                    err = 1'b0;
                end
            end
            3'b100: begin  // State 4
                if (in) begin
                    nextState = 3'b101;
                    disc = 1'b0;
                    flag = 1'b0;
                    err = 1'b0;
                end
                else begin
                    nextState = 3'b000;
                    disc = 1'b0;
                    flag = 1'b0;
                    err = 1'b0;
                end
            end
            3'b101: begin  // State 5
                if (in) begin
                    nextState = 3'b110;
                    disc = 1'b0;
                    flag = 1'b0;
                    err = 1'b0;
                end
                else begin
                    nextState = 3'b000;
                    disc = 1'b0;
                    flag = 1'b0;
                    err = 1'b0;
                end
            end
            3'b110: begin  // State 6
                if (in) begin
                    nextState = 3'b111;
                    disc = 1'b0;
                    flag = 1'b0;
                    err = 1'b1;
                end
                else begin
                    nextState = 3'b000;
                    disc = 1'b1;
                    flag = 1'b1;
                    err = 1'b0;
                end
            end
            3'b111: begin  // State 7
                if (in) begin
                    nextState = 3'b111;
                    disc = 1'b0;
                    flag = 1'b0;
                    err = 1'b1;
                end
                else begin
                    nextState = 3'b000;
                    disc = 1'b0;
                    flag = 1'b0;
                    err = 1'b0;
                end
            end
            default: begin
                nextState = 3'b000;
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
        end
        else begin
            state <= nextState;
        end
    end

endmodule