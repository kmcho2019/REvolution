module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    // State encoding
    localparam ENABLE  = 1'b0;
    localparam DISABLE = 1'b1;

    reg state;
    reg [1:0] cycle_counter;

    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            cycle_counter <= 2'd0;
            shift_ena <= 1'b1;
        end else begin
            case(state)
                ENABLE: begin
                    if (cycle_counter == 2'd3) begin
                        // Completed 4 cycles (0 to 3)
                        state <= DISABLE;
                        shift_ena <= 1'b0;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                        shift_ena <= 1'b1;
                    end
                end
                DISABLE: begin
                    // Stay here indefinitely until reset
                    shift_ena <= 1'b0;
                end
            endcase
        end
    end

endmodule