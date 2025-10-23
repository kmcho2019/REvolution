module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [2:0] state; // One-hot encoding

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b001;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        case (state)
            3'b001: begin
                if (in[3]) begin
                    out_bytes[23:16] <= in;
                    state <= 3'b010;
                end
                done <= 1'b0;
            end
            3'b010: begin
                out_bytes[15:8] <= in;
                state <= 3'b100;
                done <= 1'b0;
            end
            3'b100: begin
                out_bytes[7:0] <= in;
                state <= 3'b001;
                done <= 1'b1;
            end
        endcase
    end
end

endmodule