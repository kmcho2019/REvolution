module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam HIGH = 2'b01;
    localparam WAIT_FALL = 2'b10;

    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            data_out <= 1'b0; // Default no pulse output
            case(state)
                IDLE: begin
                    if (data_in)
                        state <= HIGH;
                    else
                        state <= IDLE;
                end
                HIGH: begin
                    if (data_in)
                        state <= HIGH;
                    else
                        state <= WAIT_FALL;
                end
                WAIT_FALL: begin
                    // Pulse 0->1->0 detected at this cycle
                    data_out <= 1'b1;
                    if (data_in)
                        state <= HIGH;   // Restart pulse if glitch
                    else
                        state <= IDLE;
                end
                default: begin
                    state <= IDLE;
                    data_out <= 1'b0;
                end
            endcase
        end
    end

endmodule