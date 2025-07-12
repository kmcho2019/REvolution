module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam STOP_WAIT = 2'b10;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (!in) begin
                        state <= RECEIVE;
                        bit_count <= 0;
                    end
                end
                
                RECEIVE: begin
                    data_reg <= {in, data_reg[7:1]};  // LSB first
                    if (bit_count == 7) begin
                        state <= STOP_WAIT;
                    end
                    bit_count <= bit_count + 1;
                end
                
                STOP_WAIT: begin
                    if (in) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    // Done signal is high when we get a valid stop bit
    assign done = (state == STOP_WAIT) && in;

endmodule