module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits for 8 states (S0 to S7)
reg [2:0] nextState;

always @(*) begin
    case(state)
        3'b000: begin // S0
            if(in) begin
                nextState = 3'b001; // S1
                disc = 0;
                flag = 0;
                err = 0;
            end else begin
                nextState = 3'b000; // S0
                disc = 0;
                flag = 0;
                err = 0;
            end
        end
        3'b001: begin // S1
            if(in) begin
                nextState = 3'b010; // S2
                disc = 0;
                flag = 0;
                err = 0;
            end else begin
                nextState = 3'b000; // S0
                disc = 0;
                flag = 0;
                err = 0;
            end
        end
        3'b010: begin // S2
            if(in) begin
                nextState = 3'b011; // S3
                disc = 0;
                flag = 0;
                err = 0;
            end else begin
                nextState = 3'b000; // S0
                disc = 0;
                flag = 0;
                err = 0;
            end
        end
        3'b011: begin // S3
            if(in) begin
                nextState = 3'b100; // S4
                disc = 0;
                flag = 0;
                err = 0;
            end else begin
                nextState = 3'b000; // S0
                disc = 0;
                flag = 0;
                err = 0;
            end
        end
        3'b100: begin // S4
            if(in) begin
                nextState = 3'b101; // S5
                disc = 0;
                flag = 0;
                err = 0;
            end else begin
                nextState = 3'b000; // S0
                disc = 0;
                flag = 0;
                err = 0;
            end
        end
        3'b101: begin // S5
            if(in) begin
                nextState = 3'b110; // S6
                disc = 0;
                flag = 0;
                err = 0;
            end else begin
                nextState = 3'b000; // S0
                disc = 0;
                flag = 0;
                err = 0;
            end
        end
        3'b110: begin // S6
            if(in) begin
                nextState = 3'b111; // S7
                disc = 0;
                flag = 0;
                err = 1;
            end else begin
                nextState = 3'b000; // S0
                disc = 1;
                flag = 1;
                err = 0;
            end
        end
        3'b111: begin // S7
            if(in) begin
                nextState = 3'b111; // S7
                disc = 0;
                flag = 0;
                err = 1;
            end else begin
                nextState = 3'b000; // S0
                disc = 0;
                flag = 0;
                err = 0;
            end
        end
        default: begin
            nextState = 3'b000; // S0
            disc = 0;
            flag = 0;
            err = 0;
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 3'b000;
    end else begin
        state <= nextState;
    end
end

endmodule