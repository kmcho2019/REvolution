module TopModule (
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [1:0] state;  // state register
reg [1:0] nextState;  // next state register

// State encoding:
// S0: 00
// S1: 01
// S2: 10
// S3: 11

always @(*) begin
    case(state)
        2'b00: begin  // S0
            if (in) begin
                nextState = 2'b01;  // S1
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end else begin
                nextState = 2'b00;  // S0
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
        end
        2'b01: begin  // S1
            if (in) begin
                nextState = 2'b10;  // S2
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end else begin
                nextState = 2'b00;  // S0
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
        end
        2'b10: begin  // S2
            if (in) begin
                nextState = 2'b11;  // S3
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end else begin
                nextState = 2'b00;  // S0
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
        end
        2'b11: begin  // S3
            if (in) begin
                nextState = 2'b11;  // S3
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b1;  // error
            end else begin
                nextState = 2'b00;  // S0
                disc = 1'b1;  // discard
                flag = 1'b1;  // flag
                err = 1'b0;
            end
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00;  // S0
    end else begin
        state <= nextState;
    end
end

endmodule