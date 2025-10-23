module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    parameter IDLE = 2'b00;
    parameter BYTE1 = 2'b01;
    parameter BYTE2 = 2'b10;
    
    reg [1:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE:   next_state = in[3] ? BYTE1 : IDLE;
            BYTE1:  next_state = BYTE2;
            BYTE2:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign done = (state == BYTE2);

endmodule