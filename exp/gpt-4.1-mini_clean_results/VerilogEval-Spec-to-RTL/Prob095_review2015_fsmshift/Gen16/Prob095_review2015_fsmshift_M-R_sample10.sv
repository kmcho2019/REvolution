module TopModule (
    input  wire clk,
    input  wire reset,   // synchronous active-high reset
    output wire shift_ena
);

    // State encoding
    localparam IDLE   = 1'b0;
    localparam ENABLE = 1'b1;

    reg state;
    reg [1:0] count_down;

    // Sequential logic: state and countdown update
    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            count_down <= 2'd3;
        end else begin
            case (state)
                ENABLE: begin
                    if (count_down == 2'd0) begin
                        state <= IDLE;
                        count_down <= 2'd0;
                    end else begin
                        count_down <= count_down - 1'b1;
                    end
                end
                IDLE: begin
                    count_down <= 2'd0;
                end
            endcase
        end
    end

    // Combinational output
    assign shift_ena = (state == ENABLE);

endmodule