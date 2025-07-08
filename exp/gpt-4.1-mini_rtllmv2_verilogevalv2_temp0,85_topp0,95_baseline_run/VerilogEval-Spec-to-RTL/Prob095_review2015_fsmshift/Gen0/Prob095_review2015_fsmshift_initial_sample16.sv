module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

    reg [2:0] count;
    reg state;

    localparam ENABLE  = 1'b1;
    localparam DISABLE = 1'b0;

    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            count <= 3'd0;
            shift_ena <= 1'b1;
        end else begin
            case(state)
                ENABLE: begin
                    if (count == 3'd3) begin
                        state <= DISABLE;
                        shift_ena <= 1'b0;
                    end else begin
                        count <= count + 1;
                        shift_ena <= 1'b1;
                    end
                end
                DISABLE: begin
                    shift_ena <= 1'b0;
                end
            endcase
        end
    end

endmodule