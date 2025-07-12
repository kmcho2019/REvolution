module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    reg [1:0] state;
    reg [23:0] out_bytes_reg;
    reg done_reg;

    // State machine states
    parameter IDLE = 2'b00;
    parameter BYTE1 = 2'b01;
    parameter BYTE2 = 2'b10;
    parameter BYTE3 = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_bytes_reg <= 24'd0;
            done_reg <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1'b1) begin
                        state <= BYTE1;
                        out_bytes_reg <= {in, 16'd0};
                    end
                end
                BYTE1: begin
                    state <= BYTE2;
                    out_bytes_reg <= {out_bytes_reg[15:0], in};
                end
                BYTE2: begin
                    state <= BYTE3;
                    out_bytes_reg <= {out_bytes_reg[7:0], in, 8'd0};
                end
                BYTE3: begin
                    state <= IDLE;
                    done_reg <= 1'b1;
                end
            endcase
        end
    end

    assign out_bytes = done_reg ? out_bytes_reg : 24'd0;
    assign done = done_reg;

    // Clear done signal on next clock cycle
    always @(posedge clk) begin
        if (done_reg) begin
            done_reg <= 1'b0;
        end
    end

endmodule