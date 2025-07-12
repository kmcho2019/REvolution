module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
    end
    else begin
        case (state)
            0: begin
                if (in[3]) begin
                    byte1 <= in;
                    state <= 1;
                end
                else begin
                    state <= 0;
                end
            end
            1: begin
                byte2 <= in;
                state <= 2;
            end
            2: begin
                byte3 <= in;
                state <= 3;
            end
            3: begin
                state <= 0;
                done <= 1;
            end
            default: state <= 0;
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        out_bytes <= 24'd0;
        done <= 0;
    end
    else begin
        if (state == 3) begin
            out_bytes <= {byte1, byte2, byte3};
            done <= 1;
        end
        else begin
            done <= 0;
        end
    end
end

endmodule