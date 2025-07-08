module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

// State encoding
localparam IDLE      = 2'b00; // waiting for 0->1
localparam HIGH      = 2'b01; // data_in=1, waiting for falling edge
localparam PULSE_END = 2'b10; // pulse detected, output 1 for one cycle

reg [1:0] state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state    <= IDLE;
        data_out <= 1'b0;
    end else begin
        state <= next_state;
        // data_out is 1 only in PULSE_END state for one cycle
        data_out <= (next_state == PULSE_END) ? 1'b1 : 1'b0;
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            // Wait for 0->1 transition to start pulse detection
            // Actually, if data_in==1, means rising edge just happened or is high
            // But we only start pulse detection if previous data_in was 0
            // Because we don't have previous data_in in combinational block,
            // assume IDLE means data_in is 0, so start HIGH when data_in==1
            if (data_in)
                next_state = HIGH;
            else
                next_state = IDLE;
        end
        HIGH: begin
            // Wait for data_in to go back to 0 to complete pulse
            if (!data_in)
                next_state = PULSE_END;
            else
                next_state = HIGH;
        end
        PULSE_END: begin
            // After outputting pulse, go back to IDLE to detect next pulse
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

endmodule