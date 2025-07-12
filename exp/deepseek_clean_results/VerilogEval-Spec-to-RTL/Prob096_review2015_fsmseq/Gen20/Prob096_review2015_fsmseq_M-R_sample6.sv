module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // States representing progress in matching the sequence
    localparam IDLE = 2'b00;
    localparam GOT1 = 2'b01;
    localparam GOT11 = 2'b10;
    localparam GOT110 = 2'b11;

    reg [1:0] state, next_state;
    reg found;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            found <= 1'b0;
        end else if (!found) begin
            state <= next_state;
            found <= (state == GOT110) && (data == 1'b1);
        end
    end

    always @(*) begin
        case (state)
            IDLE:   next_state = (data) ? GOT1 : IDLE;
            GOT1:   next_state = (data) ? GOT11 : IDLE;
            GOT11:  next_state = (data) ? GOT11 : GOT110;
            GOT110: next_state = (data) ? GOT1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    assign start_shifting = found;

endmodule