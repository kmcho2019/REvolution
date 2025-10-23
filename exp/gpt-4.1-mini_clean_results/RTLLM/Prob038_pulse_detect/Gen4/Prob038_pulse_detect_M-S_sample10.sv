module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam HIGH = 1'b1;

    reg state;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    data_out <= 1'b0;
                    if (data_in)
                        state <= HIGH;
                end
                HIGH: begin
                    if (~data_in) begin
                        data_out <= 1'b1;  // pulse end detected
                        state <= IDLE;
                    end else begin
                        data_out <= 1'b0;
                    end
                end
                default: begin
                    state <= IDLE;
                    data_out <= 1'b0;
                end
            endcase
        end
    end

endmodule