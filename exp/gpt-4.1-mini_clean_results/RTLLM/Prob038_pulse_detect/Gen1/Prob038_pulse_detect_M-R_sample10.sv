module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam S1   = 2'b01;
    localparam S2   = 2'b10;

    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    data_out <= 1'b0;
                    if (data_in == 1'b0)
                        state <= S1;
                    else
                        state <= IDLE;
                end
                S1: begin
                    data_out <= 1'b0;
                    if (data_in == 1'b1)
                        state <= S2;
                    else
                        state <= S1; // remain if data_in still 0
                end
                S2: begin
                    if (data_in == 1'b0) begin
                        state    <= S1;
                        data_out <= 1'b1;  // pulse detected at falling edge 1->0
                    end else begin
                        state    <= S2;
                        data_out <= 1'b0;
                    end
                end
                default: begin
                    state    <= IDLE;
                    data_out <= 1'b0;
                end
            endcase
        end
    end

endmodule