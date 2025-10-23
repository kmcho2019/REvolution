module TopModule (
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;

reg [2:0] state_reg;
localparam IDLE = 3'b000;
localparam START = 3'b001;
localparam DATA = 3'b010;
localparam STOP = 3'b011;

reg [2:0] state_next;
reg [7:0] out_byte_next;
reg done_next;
reg [2:0] data_count;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        out_byte_reg <= 8'b0;
        done_reg <= 1'b0;
        data_count <= 3'b0;
    end else begin
        state_reg <= state_next;
        out_byte_reg <= out_byte_next;
        done_reg <= done_next;
    end
end

always @(*) begin
    state_next = state_reg;
    out_byte_next = out_byte_reg;
    done_next = 1'b0;

    case (state_reg)
        IDLE: begin
            if (~in) begin
                state_next = START;
            end
        end
        START: begin
            if (in) begin
                state_next = IDLE;
            end else begin
                state_next = DATA;
                data_count = 3'b1;
                out_byte_next = 8'b0;
            end
        end
        DATA: begin
            out_byte_next = {out_byte_reg[6:0], in};
            data_count = data_count + 1;
            if (data_count == 8) begin
                state_next = STOP;
            end
        end
        STOP: begin
            if (in) begin
                done_next = 1'b1;
                state_next = IDLE;
            end
        end
    endcase
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule