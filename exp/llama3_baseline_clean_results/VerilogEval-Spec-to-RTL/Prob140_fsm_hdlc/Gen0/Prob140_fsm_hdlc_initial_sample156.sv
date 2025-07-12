module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [1:0] state;
reg [1:0] nextState;
reg [2:0] count;
reg [2:0] nextCount;
reg discReg;
reg flagReg;
reg errReg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // idle state
        count <= 3'b000;
        discReg <= 1'b0;
        flagReg <= 1'b0;
        errReg <= 1'b0;
    end else begin
        state <= nextState;
        count <= nextCount;
        discReg <= disc;
        flagReg <= flag;
        errReg <= err;
    end
end

always @(*) begin
    case (state)
        2'b00: begin // idle state
            if (in) begin
                nextState = 2'b01; // ones state
                nextCount = 3'b001;
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end else begin
                nextState = 2'b00; // stay in idle state
                nextCount = 3'b000;
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
        end
        2'b01: begin // ones state
            if (in) begin
                if (count == 3'b100) begin
                    nextState = 2'b10; // discard state
                    nextCount = 3'b000;
                end else begin
                    nextState = 2'b01; // stay in ones state
                    nextCount = count + 1;
                end
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end else begin
                nextState = 2'b00; // idle state
                nextCount = 3'b000;
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
        end
        2'b10: begin // discard state
            if (in) begin
                nextState = 2'b11; // flag_error state
                nextCount = count + 1;
            end else begin
                nextState = 2'b01; // ones state
                nextCount = 3'b001;
            end
            disc = 1'b1;
            flag = 1'b0;
            err = 1'b0;
        end
        2'b11: begin // flag_error state
            if (in) begin
                nextState = 2'b11; // stay in flag_error state
                nextCount = count + 1;
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b1;
            end else begin
                nextState = 2'b00; // idle state
                nextCount = 3'b000;
                disc = 1'b0;
                flag = 1'b1;
                err = 1'b0;
            end
        end
    endcase
end

assign disc = discReg;
assign flag = flagReg;
assign err = errReg;

endmodule