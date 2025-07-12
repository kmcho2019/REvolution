module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

    reg [7:0] out_byte_reg;
    reg done_reg;
    reg [2:0] state_reg;
    reg [3:0] bit_count_reg;
    reg [7:0] byte_reg;

    localparam IDLE = 3'b000;
    localparam START = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP = 3'b011;

    always @(posedge clk) begin
        if (reset) begin
            state_reg <= IDLE;
            done_reg <= 0;
            out_byte_reg <= 8'b0;
            bit_count_reg <= 4'b0;
            byte_reg <= 8'b0;
        end else begin
            case (state_reg)
                IDLE: begin
                    if (!in) begin
                        state_reg <= START;
                        bit_count_reg <= 4'b1;
                    end else begin
                        state_reg <= IDLE;
                    end
                end
                START: begin
                    state_reg <= RECEIVE;
                    byte_reg[0] <= in;
                end
                RECEIVE: begin
                    if (bit_count_reg < 8) begin
                        byte_reg[bit_count_reg] <= in;
                        bit_count_reg <= bit_count_reg + 1;
                    end else begin
                        state_reg <= STOP;
                    end
                end
                STOP: begin
                    if (in) begin
                        done_reg <= 1;
                        out_byte_reg <= byte_reg;
                        state_reg <= IDLE;
                    end else begin
                        state_reg <= STOP;
                    end
                end
            endcase
        end
    end

    assign out_byte = out_byte_reg;
    assign done = done_reg;

endmodule