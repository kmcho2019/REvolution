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
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    wire [2:0] bit_count_next = (state == RECEIVE) ? bit_count + 1 : 3'b0;

    // Single always block for state and data
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_reg <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (~in) begin
                        state <= RECEIVE;
                        bit_count <= 3'b0;
                    end
                end

                RECEIVE: begin
                    data_reg <= {in, data_reg[7:1]};  // LSB first
                    bit_count <= bit_count_next;
                    if (bit_count_next == 3'b111) begin
                        state <= STOP;
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

    // Combinational done output (Mealy-style)
    assign done = (state == STOP) && in;

endmodule