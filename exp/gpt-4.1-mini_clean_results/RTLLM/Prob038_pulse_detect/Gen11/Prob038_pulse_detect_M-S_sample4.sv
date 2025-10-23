module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg [1:0] state;
    // State encoding
    localparam WAIT_0 = 2'b00,
               WAIT_1 = 2'b01,
               WAIT_0_END = 2'b10;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= WAIT_0;
            data_out <= 1'b0;
        end else begin
            data_out <= 1'b0; // default no pulse output
            case(state)
                WAIT_0: begin
                    if (data_in == 1'b0)
                        state <= WAIT_1;
                    else
                        state <= WAIT_0;
                end
                WAIT_1: begin
                    if (data_in == 1'b1)
                        state <= WAIT_0_END;
                    else if (data_in == 1'b0)
                        state <= WAIT_1;
                    else
                        state <= WAIT_0; // fallback, safe
                end
                WAIT_0_END: begin
                    if (data_in == 1'b0) begin
                        data_out <= 1'b1;  // pulse detected
                        state <= WAIT_0;
                    end else if (data_in == 1'b1) begin
                        state <= WAIT_0_END;
                    end else begin
                        state <= WAIT_0;
                    end
                end
                default: begin
                    state <= WAIT_0;
                    data_out <= 1'b0;
                end
            endcase
        end
    end

endmodule