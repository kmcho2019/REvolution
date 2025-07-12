module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [4:0] state;
    localparam RESET  = 5'b00001,
               STATE1 = 5'b00010,
               STATE2 = 5'b00100,
               STATE3 = 5'b01000,
               IDLE   = 5'b10000;

    always @(posedge clk) begin
        if (reset) begin
            state <= RESET;
            shift_ena <= 1'b1;
        end else begin
            case (state)
                RESET: begin
                    state <= STATE1;
                    shift_ena <= 1'b1;
                end
                STATE1: begin
                    state <= STATE2;
                    shift_ena <= 1'b1;
                end
                STATE2: begin
                    state <= STATE3;
                    shift_ena <= 1'b1;
                end
                STATE3: begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                end
                default: begin  // IDLE
                    state <= IDLE;
                    shift_ena <= 1'b0;
                end
            endcase
        end
    end

endmodule