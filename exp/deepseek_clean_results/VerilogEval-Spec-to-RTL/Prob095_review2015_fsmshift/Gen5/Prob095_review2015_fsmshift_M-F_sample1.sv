module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] state;
    localparam RESET = 3'b000,
               STATE1 = 3'b001,
               STATE2 = 3'b010,
               STATE3 = 3'b011,
               IDLE = 3'b100;

    always @(posedge clk) begin
        if (reset) begin
            state <= RESET;
        end else begin
            case (state)
                RESET: state <= STATE1;
                STATE1: state <= STATE2;
                STATE2: state <= STATE3;
                STATE3: state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end

    assign shift_ena = (state == RESET) || (state == STATE1) || 
                      (state == STATE2) || (state == STATE3);

endmodule