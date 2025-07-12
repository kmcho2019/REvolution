module TopModule(
    input         clk,
    input         reset,
    input  [7:0]  in,
    output        done
);

reg [1:0] state;
reg [7:0] byte1, byte2;
reg        done_reg;

localparam IDLE = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;
localparam BYTE3 = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= BYTE1;
                end
            end
            BYTE1: begin
                byte2 <= in;
                state <= BYTE2;
            end
            BYTE2: begin
                state <= BYTE3;
            end
            BYTE3: begin
                state <= IDLE;
                done_reg <= 1'b1;
            end
        endcase
    end
end

assign done = done_reg;

always @(posedge clk) begin
    if (!reset) begin
        done_reg <= 1'b0;
    end
end

endmodule