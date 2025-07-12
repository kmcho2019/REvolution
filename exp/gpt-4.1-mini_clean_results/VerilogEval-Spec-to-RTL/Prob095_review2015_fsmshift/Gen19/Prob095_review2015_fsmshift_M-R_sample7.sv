module TopModule (
    input  wire clk,
    input  wire reset,       // synchronous active high
    output wire shift_ena
);

    // State encoding
    localparam IDLE         = 1'b0;
    localparam SHIFT_ENABLE = 1'b1;

    reg state;
    reg [2:0] cycle_count;

    always @(posedge clk) begin
        if (reset) begin
            state       <= SHIFT_ENABLE;
            cycle_count <= 3'd0;
        end else begin
            case (state)
                SHIFT_ENABLE: begin
                    if (cycle_count == 3'd3) begin
                        state <= IDLE;
                    end
                    cycle_count <= cycle_count + 1'b1;
                end
                IDLE: begin
                    cycle_count <= 3'd0;  // hold at zero in IDLE
                    state <= IDLE;
                end
                default: begin
                    state <= IDLE;
                    cycle_count <= 3'd0;
                end
            endcase
        end
    end

    assign shift_ena = (state == SHIFT_ENABLE);

endmodule