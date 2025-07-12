module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] state; // 0: IDLE, 1: SHIFT_COUNTING, 2: SHIFT_DISABLE
    logic [1:0] count; // counter to keep track of the number of clock cycles

    always_comb begin
        case(state)
            0: begin // IDLE
                if (reset) begin
                    shift_ena = 1'b1;
                    state = 1;
                    count = 2'b00;
                end
                else begin
                    shift_ena = 1'b0;
                    state = 0;
                end
            end
            1: begin // SHIFT_COUNTING
                shift_ena = 1'b1;
                if (count == 2'b11) begin
                    state = 2;
                end
            end
            2: begin // SHIFT_DISABLE
                shift_ena = 1'b0;
                state = 2;
            end
            default: begin
                shift_ena = 1'b0;
                state = 0;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 0;
            count <= 2'b00;
        end
        else begin
            case(state)
                1: begin // SHIFT_COUNTING
                    count <= count + 1'b1;
                end
                default: begin
                    count <= count;
                end
            endcase
        end
    end

endmodule