module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam DONE    = 2'b10;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (~in) begin
                        state <= RECEIVE;
                        bit_count <= 0;
                    end
                end

                RECEIVE: begin
                    data_reg <= {in, data_reg[7:1]};
                    if (bit_count == 7) begin
                        state <= DONE;
                    end
                    bit_count <= bit_count + 1;
                end

                DONE: begin
                    if (in) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    assign done = (state == DONE) && in;

endmodule