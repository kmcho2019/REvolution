module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    localparam INITIAL = 1'b0;
    localparam IDLE    = 1'b1;

    reg state;
    reg [2:0] count; // 3-bit counter to count to 4

    always @(posedge clk) begin
        if (reset) begin
            state <= INITIAL;
            count <= 3'd0;
            shift_ena <= 1'b1;
        end else begin
            case (state)
                INITIAL: begin
                    if (count == 3'd3) begin
                        shift_ena <= 1'b0;
                        state <= IDLE;
                    end else begin
                        count <= count + 3'd1;
                        shift_ena <= 1'b1;
                    end
                end

                IDLE: begin
                    shift_ena <= 1'b0;
                end

                default: begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                end
            endcase
        end
    end

endmodule