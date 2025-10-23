module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg;
reg [3:0] data_count_reg;
reg [7:0] data_reg;

localparam IDLE = 3'b001;
localparam START_BIT = 3'b010;
localparam DATA_BITS = 3'b011;
localparam STOP_BIT = 3'b100;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg <= IDLE;
        data_count_reg <= 4'd0;
        out_byte_reg <= 8'd0;
        done_reg <= 1'b0;
        data_reg <= 8'd0;
    end else begin
        case (state_reg)
            IDLE: begin
                if (!in) begin
                    state_reg <= START_BIT;
                end
            end
            START_BIT: begin
                state_reg <= DATA_BITS;
            end
            DATA_BITS: begin
                data_reg <= {data_reg[6:0], in};
                data_count_reg <= data_count_reg + 1'b1;
                if (data_count_reg == 4'd7) begin
                    state_reg <= STOP_BIT;
                end
            end
            STOP_BIT: begin
                if (in) begin
                    out_byte_reg <= data_reg;
                    done_reg <= 1'b1;
                    state_reg <= IDLE;
                    data_count_reg <= 4'd0;
                end
            end
            default: begin
                state_reg <= IDLE;
            end
        endcase
        if (state_reg!= STOP_BIT) begin
            done_reg <= 1'b0;
        end
        if (in && (state_reg == IDLE)) begin
            state_reg <= IDLE;
        end
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule