module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output [23:0] out_bytes,
    output        done
);

reg [23:0] out_bytes_reg;
reg         done_reg;
reg [1:0]   state_reg;

localparam IDLE = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;
localparam DONE = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        out_bytes_reg <= 24'd0;
        done_reg <= 1'b0;
        state_reg <= IDLE;
    end else begin
        case (state_reg)
            IDLE: begin
                if (in[3]) begin
                    out_bytes_reg[23:16] <= in;
                    state_reg <= BYTE1;
                end
            end
            BYTE1: begin
                out_bytes_reg[15:8] <= in;
                state_reg <= BYTE2;
            end
            BYTE2: begin
                out_bytes_reg[7:0] <= in;
                state_reg <= DONE;
            end
            DONE: begin
                state_reg <= IDLE;
            end
        endcase
        done_reg <= (state_reg == DONE);
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule