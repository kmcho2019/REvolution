module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam WAIT    = 2'b11;

    reg [1:0] state;
    reg [7:0] data_shift;
    reg [2:0] bit_count;
    wire terminal_count = (bit_count == 3'b111);

    // State transitions (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_shift <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (~in) begin
                        state <= RECEIVE;
                        bit_count <= 3'b0;
                    end
                end

                RECEIVE: begin
                    data_shift <= {in, data_shift[7:1]};  // LSB first
                    if (terminal_count) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end

                STOP: begin
                    if (in) begin
                        state <= IDLE;
                    end else begin
                        state <= WAIT;
                    end
                end

                WAIT: begin
                    if (in) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    // Output logic (combinational)
    assign done = (state == STOP) && in;

endmodule