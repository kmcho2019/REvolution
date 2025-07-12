module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 3 states: IDLE, START_BIT, DATA_BITS, STOP_BIT
localparam IDLE = 3'b001;
localparam START_BIT = 3'b010;
localparam DATA_BITS = 3'b011;
localparam STOP_BIT = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        out_byte_reg <= 8'd0;
        done_reg <= 1'b0;
    end else begin
        case (state_reg)
            IDLE: begin
                if (~in) begin // start bit detected
                    state_reg <= START_BIT;
                end else begin
                    state_reg <= IDLE;
                end
            end
            START_BIT: begin
                state_reg <= DATA_BITS;
            end
            DATA_BITS: begin
                out_byte_reg <= {out_byte_reg[6:0], in}; // shift in the data bit
                if (out_byte_reg[7] == 1'b1) begin // 8 data bits received
                    state_reg <= STOP_BIT;
                end
            end
            STOP_BIT: begin
                if (in) begin // stop bit verified
                    done_reg <= 1'b1;
                    state_reg <= IDLE;
                end else begin // stop bit not verified, wait for stop bit
                    state_reg <= STOP_BIT;
                end
            end
            default: state_reg <= IDLE;
        endcase
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

always @(posedge clk) begin
    if (state_reg == STOP_BIT) begin
        if (in) begin
            done_reg <= 1'b1;
        end else begin
            done_reg <= 1'b0;
        end
    end else begin
        done_reg <= 1'b0;
    end
end

endmodule