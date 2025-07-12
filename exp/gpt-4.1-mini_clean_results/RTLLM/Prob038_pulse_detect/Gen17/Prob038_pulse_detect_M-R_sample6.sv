module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE = 2'd0;
    localparam HIGH = 2'd1;
    localparam LOW  = 2'd2;

    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            data_out <= 1'b0;  // Default output

            case (state)
                IDLE: begin
                    if (data_in)
                        state <= HIGH;
                    else
                        state <= IDLE;
                end

                HIGH: begin
                    if (~data_in)
                        state <= LOW;
                    else
                        state <= HIGH;
                end

                LOW: begin
                    data_out <= 1'b1;  // Output pulse detected at end of LOW state
                    if (data_in)
                        state <= HIGH;
                    else
                        state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule