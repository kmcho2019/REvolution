module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding - 3 bits for 5 states
    reg [2:0] state;
    localparam IDLE   = 0;
    localparam GOT1   = 1;
    localparam GOT11  = 2;
    localparam GOT110 = 3;
    localparam FOUND  = 4;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_shifting <= 0;
        end else begin
            case (state)
                IDLE:   state <= data ? GOT1 : IDLE;
                GOT1:   state <= data ? GOT11 : IDLE;
                GOT11:  state <= data ? GOT11 : GOT110;
                GOT110: state <= data ? FOUND : IDLE;
                FOUND:  state <= FOUND;
            endcase
            start_shifting <= (state == FOUND);
        end
    end

endmodule