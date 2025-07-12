module TopModule (
    input  wire clk,
    input  wire reset,   // synchronous active-high reset
    output wire shift_ena
);

    // State encoding
    localparam IDLE   = 1'b0;
    localparam ENABLE = 1'b1;

    reg state;
    reg [1:0] cycle_count; // to count 4 cycles

    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            cycle_count <= 2'd0;
        end else begin
            case (state)
                ENABLE: begin
                    if (cycle_count == 2'd3) begin
                        state <= IDLE;
                    end
                    cycle_count <= cycle_count + 1'b1;
                end
                IDLE: begin
                    cycle_count <= 2'd0;
                end
            endcase
        end
    end

    assign shift_ena = (state == ENABLE);

endmodule