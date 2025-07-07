module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    // State encoding
    localparam INIT = 1'b0;
    localparam IDLE = 1'b1;

    reg state;
    reg [2:0] count; // 3 bits to count up to 4

    always @(posedge clk) begin
        if (reset) begin
            state <= INIT;
            count <= 3'd0;
            shift_ena <= 1'b1;
        end else begin
            case (state)
                INIT: begin
                    if (count == 3'd3) begin
                        shift_ena <= 1'b0;
                        state <= IDLE;
                    end else begin
                        count <= count + 1;
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