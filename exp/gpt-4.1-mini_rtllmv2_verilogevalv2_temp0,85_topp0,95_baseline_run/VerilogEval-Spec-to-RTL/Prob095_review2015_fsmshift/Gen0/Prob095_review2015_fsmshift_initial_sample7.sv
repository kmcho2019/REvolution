module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    typedef enum logic [0:0] {
        INIT = 1'b0,
        IDLE = 1'b1
    } state_t;

    state_t state;
    reg [1:0] count; // 2-bit counter to count up to 4 cycles

    always @(posedge clk) begin
        if (reset) begin
            state <= INIT;
            count <= 2'b00;
            shift_ena <= 1'b1;
        end else begin
            case(state)
                INIT: begin
                    if (count == 2'd3) begin
                        state <= IDLE;
                        shift_ena <= 1'b0;
                    end else begin
                        count <= count + 1'b1;
                        shift_ena <= 1'b1;
                    end
                end
                IDLE: begin
                    shift_ena <= 1'b0;
                end
            endcase
        end
    end

endmodule