module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding
    localparam [1:0] IDLE = 2'b00;
    localparam [1:0] GOT1 = 2'b01;
    localparam [1:0] GOT11 = 2'b10;
    localparam [1:0] GOT110 = 2'b11;

    reg [1:0] state, next_state;
    wire clk_en = !start_shifting; // Clock gating when pattern found

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_shifting <= 1'b0;
        end else if (clk_en) begin
            state <= next_state;
            start_shifting <= (next_state == GOT110) && data;
        end
    end

    always @(*) begin
        case (state)
            IDLE:   next_state = data ? GOT1 : IDLE;
            GOT1:   next_state = data ? GOT11 : IDLE;
            GOT11:  next_state = data ? GOT11 : GOT110;
            GOT110: next_state = data ? GOT1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule