module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

    // States encoding
    typedef enum reg [0:0] {
        ASSERT_SHIFT = 1'b0,
        DONE = 1'b1
    } state_t;

    reg [1:0] count;
    reg state_t state;

    always @(posedge clk) begin
        if (reset) begin
            state <= ASSERT_SHIFT;
            count <= 2'd0;
            shift_ena <= 1'b1;
        end else begin
            case(state)
                ASSERT_SHIFT: begin
                    if (count == 2'd3) begin
                        shift_ena <= 1'b0;
                        state <= DONE;
                    end else begin
                        count <= count + 1'b1;
                        shift_ena <= 1'b1;
                    end
                end
                DONE: begin
                    shift_ena <= 1'b0;
                end
            endcase
        end
    end

endmodule