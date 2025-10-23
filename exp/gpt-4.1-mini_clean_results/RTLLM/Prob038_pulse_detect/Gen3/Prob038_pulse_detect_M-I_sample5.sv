module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding using localparams for clarity and simple logic
    localparam IDLE = 2'd0;
    localparam HIGH = 2'd1;
    localparam LOW  = 2'd2;

    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_in)
                        state <= HIGH;
                    else
                        state <= IDLE;
                    data_out <= 1'b0;
                end

                HIGH: begin
                    if (~data_in) begin
                        state <= LOW;
                        data_out <= 1'b1;  // Pulse ends at HIGH->LOW transition
                    end else begin
                        state <= HIGH;
                        data_out <= 1'b0;
                    end
                end

                LOW: begin
                    if (data_in)
                        state <= HIGH;
                    else
                        state <= IDLE;
                    data_out <= 1'b0;
                end

                default: begin
                    state <= IDLE;
                    data_out <= 1'b0;
                end
            endcase
        end
    end

endmodule