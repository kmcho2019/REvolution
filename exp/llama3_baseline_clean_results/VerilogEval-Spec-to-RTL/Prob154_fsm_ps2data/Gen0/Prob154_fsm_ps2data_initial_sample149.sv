module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // 0: SEARCH, 1: BYTE1, 2: BYTE2, 3: BYTE3
reg [23:0] out_bytes_reg;
reg done_reg;

// State Machine
always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        done_reg <= 0;
        out_bytes_reg <= 0;
    end else begin
        case(state)
            0: begin // SEARCH
                if(in[3]) begin
                    state <= 1;
                    out_bytes_reg[23:16] <= in;
                end else begin
                    state <= 0;
                end
            end
            1: begin // BYTE1
                state <= 2;
                out_bytes_reg[15:8] <= in;
            end
            2: begin // BYTE2
                state <= 3;
                out_bytes_reg[7:0] <= in;
            end
            3: begin // BYTE3
                done_reg <= 1;
                state <= 0;
            end
            default: begin
                state <= 0;
            end
        endcase
    end
end

// Output Logic
always @(posedge clk) begin
    if(reset) begin
        out_bytes <= 0;
        done <= 0;
    end else begin
        out_bytes <= out_bytes_reg;
        if(done_reg) begin
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

endmodule