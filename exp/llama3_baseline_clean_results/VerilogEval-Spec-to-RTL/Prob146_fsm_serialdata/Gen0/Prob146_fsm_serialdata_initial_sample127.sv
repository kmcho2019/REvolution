module TopModule(
    input           clk,
    input           in,
    input           reset,
    output  [7:0]   out_byte,
    output          done
);

reg [7:0] out_byte_reg;
reg       done_reg;

reg [2:0] state_reg;
localparam IDLE         = 3'b001;
localparam START_BIT    = 3'b010;
localparam DATA_BITS    = 3'b011;
localparam STOP_BIT     = 3'b100;

reg [2:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        state_reg     <= IDLE;
        out_byte_reg  <= 8'b0;
        done_reg      <= 1'b0;
    end else begin
        case (state_reg)
            IDLE: begin
                if (in == 1'b0) begin
                    state_reg     <= START_BIT;
                    out_byte_reg  <= 8'b0;
                end else begin
                    state_reg     <= IDLE;
                end
            end
            START_BIT: begin
                state_reg     <= DATA_BITS;
                out_byte_reg  <= {out_byte_reg[6:0], in};
            end
            DATA_BITS: begin
                if (out_byte_reg[7] == 1'b0) begin
                    state_reg     <= DATA_BITS;
                    out_byte_reg  <= {out_byte_reg[6:0], in};
                end else begin
                    state_reg     <= STOP_BIT;
                    out_byte_reg  <= {out_byte_reg[6:0], in};
                end
            end
            STOP_BIT: begin
                if (in == 1'b1) begin
                    state_reg     <= IDLE;
                    done_reg      <= 1'b1;
                end else begin
                    state_reg     <= STOP_BIT;
                end
            end
        endcase
    end
end

assign out_byte  = out_byte_reg;
assign done     = done_reg;

endmodule