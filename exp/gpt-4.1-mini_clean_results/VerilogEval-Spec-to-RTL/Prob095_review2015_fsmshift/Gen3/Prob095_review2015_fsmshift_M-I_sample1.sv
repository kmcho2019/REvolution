module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    // State encoding
    localparam IDLE   = 1'b0;
    localparam ENABLE = 1'b1;

    reg state;
    reg [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            count <= 2'd0;
            shift_ena <= 1'b1;
        end else begin
            case (state)
                ENABLE: begin
                    if (count == 2'd3) begin
                        state <= IDLE;
                        count <= 2'd0;
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