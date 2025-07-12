module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] byte;
reg [2:0] state;
reg [2:0] nextState;
reg done_reg;

always @(*) begin
    case(state)
        3'b000: begin // IDLE
            if (!in) begin
                nextState = 3'b001; // START
            end else begin
                nextState = 3'b000; // IDLE
            end
        end
        3'b001: begin // START
            nextState = 3'b010; // DATA
        end
        3'b010: begin // DATA
            if (byte == 8'b11111111) begin
                nextState = 3'b011; // STOP
            end else begin
                nextState = 3'b010; // DATA
            end
        end
        3'b011: begin // STOP
            if (in) begin
                nextState = 3'b100; // DONE
            end else begin
                nextState = 3'b011; // STOP
            end
        end
        3'b100: begin // DONE
            nextState = 3'b000; // IDLE
        end
        default: begin
            nextState = 3'b000; // IDLE
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
        done_reg <= 0;
        byte <= 0;
    end else begin
        state <= nextState;
        if (state == 3'b010) begin // DATA
            byte <= byte + 1;
        end else if (state == 3'b100) begin // DONE
            done_reg <= 1;
        end else begin
            done_reg <= 0;
        end
        if (state == 3'b010) begin // DATA
            if (in) begin
                out_byte[byte] <= 1;
            end else begin
                out_byte[byte] <= 0;
            end
        end
        if (state == 3'b011) begin // STOP
            byte <= 0;
        end
    end
end

assign done = done_reg;

endmodule