module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        out_bytes <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin
                if (in[3]) begin
                    out_bytes[23:16] <= in;
                    state <= 1;
                end
            end
            1: begin
                out_bytes[15:8] <= in;
                state <= 2;
            end
            2: begin
                out_bytes[7:0] <= in;
                state <= 0;
                done <= 1;
            end
        endcase
        if (state != 2) done <= 0;
    end
end

endmodule