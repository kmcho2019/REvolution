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
reg [2:0] next_state;
reg [7:0] data_reg;
reg [2:0] bit_counter;

localparam IDLE = 3'b000;
localparam START = 3'b001;
localparam DATA = 3'b010;
localparam STOP = 3'b011;
localparam ERROR = 3'b100;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg <= IDLE;
        out_byte_reg <= 8'b0;
        done_reg <= 1'b0;
        data_reg <= 8'b0;
        bit_counter <= 3'b0;
    end
    else begin
        case (state_reg)
            IDLE: begin
                if (in == 1'b0) begin // start bit received
                    state_reg <= START;
                    data_reg <= 8'b0;
                    bit_counter <= 3'b0;
                end
                else begin
                    state_reg <= IDLE;
                end
            end
            START: begin
                state_reg <= DATA;
            end
            DATA: begin
                data_reg <= {data_reg[6:0], in};
                bit_counter <= bit_counter + 1;
                if (bit_counter == 3'b111) begin
                    state_reg <= STOP;
                end
                else begin
                    state_reg <= DATA;
                end
            end
            STOP: begin
                if (in == 1'b1) begin // stop bit received
                    out_byte_reg <= data_reg;
                    done_reg <= 1'b1;
                    state_reg <= IDLE;
                end
                else begin
                    state_reg <= ERROR;
                end
            end
            ERROR: begin
                if (in == 1'b1) begin // stop bit received
                    state_reg <= IDLE;
                end
                else begin
                    state_reg <= ERROR;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (done_reg) begin
        done <= 1'b1;
    end
    else begin
        done <= 1'b0;
    end
    out_byte <= out_byte_reg;
end

endmodule