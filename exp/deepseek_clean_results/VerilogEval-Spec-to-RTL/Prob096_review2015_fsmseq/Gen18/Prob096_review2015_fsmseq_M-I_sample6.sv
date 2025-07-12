module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    typedef enum logic [1:0] {
        IDLE,
        GOT1,
        GOT11,
        GOT110
    } state_t;

    reg [1:0] state;
    reg found;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            found <= 1'b0;
        end else if (!found) begin
            case (state)
                IDLE:   state <= (data) ? GOT1 : IDLE;
                GOT1:   state <= (data) ? GOT11 : IDLE;
                GOT11:  state <= (data) ? GOT11 : GOT110;
                GOT110: begin
                    found <= (data) ? 1'b1 : 1'b0;
                    state <= (data) ? GOT1 : IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

    assign start_shifting = found;

endmodule