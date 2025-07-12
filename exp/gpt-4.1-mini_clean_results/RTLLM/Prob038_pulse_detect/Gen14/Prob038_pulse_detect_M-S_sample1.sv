module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // States:
    // 0: waiting for 0 (idle)
    // 1: detected 0->1 rising edge
    reg state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= 1'b0;
            data_out <= 1'b0;
        end else begin
            case(state)
                1'b0: begin
                    data_out <= 1'b0;
                    if (data_in == 1'b1)
                        state <= 1'b1; // rising edge detected (0->1)
                end
                1'b1: begin
                    if (data_in == 1'b0) begin
                        data_out <= 1'b1; // 0->1->0 pulse completed
                        state    <= 1'b0;
                    end else begin
                        data_out <= 1'b0;
                        // remain in state 1 waiting for falling edge
                    end
                end
            endcase
        end
    end

endmodule