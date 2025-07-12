module TopModule(
    input           clk,
    input           in,
    input           reset,
    output [7:0]    out_byte,
    output          done
);

    reg [2:0] state;
    reg [7:0] data;
    reg [2:0] bit_counter;
    reg [7:0] out_byte_reg;
    reg        done_reg;

    localparam IDLE = 3'b000;
    localparam RECEIVE_DATA = 3'b001;
    localparam VERIFY_STOP = 3'b010;

    always @ (posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 3'b000;
            done_reg <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (~in) begin
                        state <= RECEIVE_DATA;
                        data <= 8'b0;
                        bit_counter <= 3'b001;
                    end
                    done_reg <= 1'b0;
                end
                RECEIVE_DATA: begin
                    data <= {data[6:0], in};
                    bit_counter <= bit_counter + 1'b1;
                    if (bit_counter == 3'b100) begin
                        state <= VERIFY_STOP;
                    end
                end
                VERIFY_STOP: begin
                    if (in) begin
                        out_byte_reg <= data;
                        done_reg <= 1'b1;
                        state <= IDLE;
                    end else begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    assign out_byte = out_byte_reg;
    assign done = done_reg;

endmodule