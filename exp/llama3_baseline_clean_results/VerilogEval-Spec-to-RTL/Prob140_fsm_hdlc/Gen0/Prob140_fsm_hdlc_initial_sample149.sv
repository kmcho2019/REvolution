module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits to represent 8 states (0 to 7)
reg [2:0] nextState;

always @(*) begin
    case (state)
        3'b000: begin // S0
            if (in == 1'b1) begin
                nextState = 3'b001; // S1
            end else begin
                nextState = 3'b000; // S0
            end
            disc = 1'b0;
            flag = 1'b0;
            err = 1'b0;
        end
        3'b001: begin // S1
            if (in == 1'b1) begin
                nextState = 3'b010; // S2
            end else begin
                nextState = 3'b000; // S0
            end
            disc = 1'b0;
            flag = 1'b0;
            err = 1'b0;
        end
        3'b010: begin // S2
            if (in == 1'b1) begin
                nextState = 3'b011; // S3
            end else begin
                nextState = 3'b000; // S0
            end
            disc = 1'b0;
            flag = 1'b0;
            err = 1'b0;
        end
        3'b011: begin // S3
            if (in == 1'b1) begin
                nextState = 3'b100; // S4
            end else begin
                nextState = 3'b000; // S0
            end
            disc = 1'b0;
            flag = 1'b0;
            err = 1'b0;
        end
        3'b100: begin // S4
            if (in == 1'b1) begin
                nextState = 3'b101; // S5
            end else begin
                nextState = 3'b000; // S0
            end
            disc = 1'b0;
            flag = 1'b0;
            err = 1'b0;
        end
        3'b101: begin // S5
            if (in == 1'b1) begin
                nextState = 3'b110; // S6
            end else begin
                nextState = 3'b000; // S0
                disc = 1'b1; // discard this bit
            end
            flag = 1'b0;
            err = 1'b0;
        end
        3'b110: begin // S6
            if (in == 1'b1) begin
                nextState = 3'b111; // S7
            end else begin
                nextState = 3'b000; // S0
                flag = 1'b1; // flag this sequence
            end
            disc = 1'b0;
            err = 1'b0;
        end
        3'b111: begin // S7
            disc = 1'b0;
            flag = 1'b0;
            err = 1'b1; // error
            if (in == 1'b0) begin
                nextState = 3'b000; // S0
            end else begin
                nextState = 3'b111; // S7
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset == 1'b1) begin
        state <= 3'b000; // reset to S0
    end else begin
        state <= nextState;
    end
end

endmodule