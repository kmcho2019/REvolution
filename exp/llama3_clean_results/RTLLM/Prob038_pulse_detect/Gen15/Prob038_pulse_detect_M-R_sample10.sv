module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // State register to track the pulse detection process
                // 0: Initial state, waiting for rising edge
                // 1: Detected rising edge, waiting for falling edge
                // 2: Detected pulse, generate output

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 0;
        data_out <= 0;
    end else begin
        case (state)
            0: begin // Waiting for rising edge
                if (data_in) begin
                    state <= 1;
                    data_out <= 0;
                end else begin
                    state <= 0;
                    data_out <= 0;
                end
            end
            1: begin // Waiting for falling edge
                if (!data_in) begin
                    state <= 2;
                    data_out <= 1;
                end else begin
                    state <= 1;
                    data_out <= 0;
                end
            end
            2: begin // Detected pulse, return to initial state
                state <= 0;
                data_out <= 0;
            end
            default: begin
                state <= 0;
                data_out <= 0;
            end
        endcase
    end
end

endmodule