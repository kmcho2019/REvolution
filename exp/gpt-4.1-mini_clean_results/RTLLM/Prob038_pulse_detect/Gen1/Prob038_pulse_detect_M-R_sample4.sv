module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding using parameters
    localparam IDLE      = 2'b00;
    localparam HIGH      = 2'b01;
    localparam PULSE_END = 2'b10;

    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    data_out <= 1'b0;
                    if (data_in == 1'b1)
                        state <= HIGH;
                    else
                        state <= IDLE;
                end
                HIGH: begin
                    if (data_in == 1'b0) begin
                        state <= PULSE_END;
                        data_out <= 1'b1; // pulse end detected here
                    end else begin
                        state <= HIGH;
                        data_out <= 1'b0;
                    end
                end
                PULSE_END: begin
                    data_out <= 1'b0;
                    if (data_in == 1'b0)
                        state <= IDLE;
                    else
                        state <= HIGH; // New pulse may start immediately
                end
                default: begin
                    state <= IDLE;
                    data_out <= 1'b0;
                end
            endcase
        end
    end

endmodule