module pulse_detect (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

    reg [1:0] state; // 0: wait for 0; 1: got 0 wait for 1; 2: got 1 wait for 0

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00;
            data_out <= 1'b0;
        end else begin
            data_out <= 1'b0;  // default output

            case (state)
                2'b00: begin
                    // Wait for data_in == 0 to start pulse detection
                    if (data_in == 1'b0)
                        state <= 2'b01;
                    else
                        state <= 2'b00;
                end
                2'b01: begin
                    // Got 0, wait for rising edge
                    if (data_in == 1'b1)
                        state <= 2'b10;
                    else
                        state <= 2'b01; // stay waiting for rising edge
                end
                2'b10: begin
                    // Got rising edge, wait for falling edge to complete pulse
                    if (data_in == 1'b0) begin
                        data_out <= 1'b1;  // pulse detected
                        state <= 2'b00;    // reset to wait for next pulse
                    end else
                        state <= 2'b10;    // still waiting
                end
                default: state <= 2'b00;
            endcase
        end
    end

endmodule